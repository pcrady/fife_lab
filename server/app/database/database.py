from pathlib import Path
from filelock import FileLock
from typing import Final, List
from tinydb import TinyDB, Query
from tinydb.storages import JSONStorage
from app.models.models import CONFIG_KEY, IMAGE_KEY, AbstractImage, Config
from glob import glob
from os.path import basename, join

from app.utils.app_logging import stderr_print, stdout_print


class ConfigDB:
    config_db_path: Final[Path] = Path('database').joinpath('db.json')
    _db_lock: Final = FileLock(f"{config_db_path}.lock")


    @staticmethod
    def set_project_config(config: Config) -> None:
        with ConfigDB._db_lock:
            db = TinyDB(ConfigDB.config_db_path, storage=JSONStorage)
            q = Query()
            db.upsert(config.model_dump(), q.key == config.key)
    
   
    @staticmethod
    def get_project_config() -> Config | None:
        with ConfigDB._db_lock:
            db = TinyDB(ConfigDB.config_db_path, storage=JSONStorage)
            query = Query()
            items = db.search(query.key == CONFIG_KEY)
        if not items:
            return None
        elif len(items) == 1:
            return Config(**items[0])
        else:
            raise Exception("More than one config has been found in the database")


    @staticmethod  
    def get_project_dir() -> Path | None:
        config = ConfigDB.get_project_config()
        if not config:
            return None
        else:
            return Path(config.project_path)


    @staticmethod  
    def get_images_dir() -> Path | None:
        project_dir = ConfigDB.get_project_dir()
        if not project_dir:
            return None
        else:
            return Path(project_dir).joinpath('images')



class ProjectDB:
    @staticmethod
    def _get_db_path() -> Path | None:
        """
        Gets the project database path
        """
        project_dir = ConfigDB.get_project_dir()
        if project_dir:
            project_db_path: Path = project_dir.joinpath('project_db.json')
            return project_db_path
        else: 
            return None


    @staticmethod
    def _get_db_lockfile():
        """
        returns the ProjectDB FileLock
        """
        db_path = ProjectDB._get_db_path()
        if not db_path:
            return None
        db_lock = FileLock(f"{db_path}.lock")
        return db_lock

    
    @staticmethod
    def _get_image_thumbnail_pairs(project_dir: str) -> list[tuple[str,str]]:
        image_dir = join(project_dir, "images")
        all_names = { basename(p) for p in glob(f"{image_dir}/*.png") }
        pairs: list[tuple[str,str]] = []
    
        for name in sorted(all_names):
            if name.startswith("thumbnail_"):
                continue
    
            thumb = f"thumbnail_{name}"
            if thumb not in all_names:
                # do this because its possible that another worker has not finished writing a thumbnail.
                # the missing data will be added by that worker
                continue
            pairs.append((name, thumb))
    
        return pairs


    @staticmethod
    def set_images() -> None:
        """
        Inserts the names of images that are inside the "images" directory
        into the project database, but only if they’re not already present.
        """
        project_dir = ConfigDB.get_project_dir()
        db_path: Final = ProjectDB._get_db_path()
        lockfile: Final = ProjectDB._get_db_lockfile()
        if db_path is None or lockfile is None:
            return

        with lockfile:
            db = TinyDB(db_path, storage=JSONStorage)
            ImageQ = Query()

            image_name_touples = ProjectDB._get_image_thumbnail_pairs(str(project_dir))

            for name in image_name_touples:
                # only insert if no existing record has this image_name
                if not db.contains(ImageQ.image_name == name[0]):
                    db.insert(AbstractImage(image_name=name[0], image_thumbnail_name=name[1]).model_dump())


    @staticmethod
    def get_images() -> List[AbstractImage] | None:
        """
        returns all images from database
        """
        db_path: Final = ProjectDB._get_db_path()
        lockfile: Final = ProjectDB._get_db_lockfile()
        images_dir = ConfigDB.get_images_dir()
 
        if db_path is None or lockfile is None or images_dir is None:
            return None

        with lockfile:
            db = TinyDB(db_path, storage=JSONStorage)
            query = Query()
            items = db.search(query.key == IMAGE_KEY)
        if not items:
            return None

        images = []
        for item in items:
            image = AbstractImage(**item) 
            image.image_path = str(images_dir.joinpath(image.image_name))
            image.image_thumbnail_path = str(images_dir.joinpath(image.image_thumbnail_name))
            images.append(image)
        return images
 

    @staticmethod
    def get_image_paths() -> List[Path] | None:
        """
        Essentially a getter that converts the AbstractImages into actual paths
        """
        images_dir = ConfigDB.get_images_dir()
        if not images_dir:
            return None

        images: List[AbstractImage] | None = ProjectDB.get_images()

        if not images:
            return None

        return [images_dir.joinpath(image.image_name) for image in images]


