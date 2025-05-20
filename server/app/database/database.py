from pathlib import Path
from filelock import FileLock
from typing import Final, List
from tinydb import TinyDB, Query
from tinydb.storages import JSONStorage
from app.models.models import CONFIG_KEY, IMAGE_KEY, AbstractImage, Config
from os.path import exists
from os import remove

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


    """
    get images directory, create it if it doesnt exist
    """
    @staticmethod  
    def get_images_dir() -> Path | None:
        project_dir = ConfigDB.get_project_dir()
        if not project_dir:
            return None
        else:
            images_dir = Path(project_dir).joinpath('images')
            images_dir.mkdir(exist_ok=True)
            return images_dir



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


    # TODO have this return an actual AbstractImage
    @staticmethod
    def _get_image_thumbnail_pairs(image_dir: Path) -> list[tuple[str, str]]:
        all_pngs = [p.name for p in image_dir.iterdir() if p.is_file() and p.suffix.lower() == ".png"]

        thumbs = {name[len("thumbnail_"):]
                  for name in all_pngs
                  if name.startswith("thumbnail_")}

        return [
            (name, f"thumbnail_{name}")
            for name in all_pngs
            if not name.startswith("thumbnail_") and name in thumbs
        ]

    @staticmethod
    def set_images() -> None:
        """
        Inserts any new images from the "images" dir into the project DB,
        skipping ones already present.
        """
        db_path = ProjectDB._get_db_path()
        lockfile = ProjectDB._get_db_lockfile()
        image_dir = ConfigDB.get_images_dir()

        if db_path is None or lockfile is None or image_dir is None:
            return

        pairs = ProjectDB._get_image_thumbnail_pairs(image_dir)
        if not pairs:
            return  # no work

        with lockfile:
            db = TinyDB(db_path, storage=JSONStorage)
            existing = {r["image_name"] for r in db.all()}

            to_insert = []
            for name, thumb in pairs:
                if name not in existing:
                    to_insert.append({
                        "image_name": name,
                        "image_thumbnail_name": thumb,
                        "key": IMAGE_KEY,
                    })

            if to_insert:
                db.insert_multiple(to_insert)   


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

    @staticmethod
    def delete_images(images: List[AbstractImage]) -> None:
        """
        Delete lists of images from the database and remove them from the images directory
        """
        db_path: Final = ProjectDB._get_db_path()
        lockfile: Final = ProjectDB._get_db_lockfile()
        images_dir = ConfigDB.get_images_dir()
 
        if db_path is None or lockfile is None or images_dir is None:
            return None

        with lockfile:
            db = TinyDB(db_path, storage=JSONStorage)
            query = Query()
            image_names =[image.image_name for image in images]
            db.remove(query.image_name.one_of(image_names))

        for image in images:
            if image.image_path is not None and exists(image.image_path):
                remove(image.image_path)
            if image.image_thumbnail_path is not None and exists(image.image_thumbnail_path):
                remove(image.image_thumbnail_path)

    @staticmethod
    def delete_everyting() -> None:
        db_path: Final = ProjectDB._get_db_path()
        lockfile: Final = ProjectDB._get_db_lockfile()
        images_dir = ConfigDB.get_images_dir()
 
        if db_path is None or lockfile is None or images_dir is None:
            return None

        images = ProjectDB.get_images()

        with lockfile:
            db = TinyDB(db_path, storage=JSONStorage)
            db.truncate()

        if not images: 
            return;
 
        for image in images:
            if image.image_path is not None and exists(image.image_path):
                remove(image.image_path)
            if image.image_thumbnail_path is not None and exists(image.image_thumbnail_path):
                remove(image.image_thumbnail_path)





 
