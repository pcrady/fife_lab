from pathlib import Path
from filelock import FileLock
from typing import Final, List
from tinydb import TinyDB, Query
from tinydb.storages import JSONStorage
from app.models.models import CONFIG_KEY, Config
from glob import glob
from os.path import basename


class ConfigDB:
    config_db_path: Final[Path] = Path('database').joinpath('db.json')
    __db_lock: Final = FileLock(f"{config_db_path}.lock")


    @staticmethod
    def set_project_config(config: Config) -> None:
        with ConfigDB.__db_lock:
            db = TinyDB(ConfigDB.config_db_path, storage=JSONStorage)
            q = Query()
            db.upsert(config.model_dump(), q.key == config.key)
    
   
    @staticmethod
    def get_project_config() -> Config | None:
        with ConfigDB.__db_lock:
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
    def __get_db_path() -> Path | None:
        project_dir = ConfigDB.get_project_dir()
        if project_dir:
            project_db_path: Path = project_dir.joinpath('project_db.json')
            return project_db_path
        else: 
            return None


    @staticmethod
    def __get_db_lockfile():
        db_path = ProjectDB.__get_db_path()
        if not db_path:
            return None
        __db_lock = FileLock(f"{db_path}.lock")
        return __db_lock


    @staticmethod
    def set_images() -> None:
        project_dir = ConfigDB.get_project_dir()
        db_path: Final = ProjectDB.__get_db_path()
        lockfile: Final = ProjectDB.__get_db_lockfile()

        if db_path is None or lockfile is None:
            return None

        with lockfile:
            db = TinyDB(db_path, storage=JSONStorage)
            image_names = [
                basename(path) for path in glob(f"{project_dir}/images/*.png") if not basename(path).startswith("thumbnail_")
            ]

            items = [{'image_name': image_name} for image_name in image_names]
            db.insert_multiple(items)


    @staticmethod
    def get_images() -> List | None:
        pass

