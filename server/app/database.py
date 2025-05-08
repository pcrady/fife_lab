from pathlib import Path
from filelock import FileLock
from typing import Final
from tinydb import TinyDB, Query
from tinydb.storages import JSONStorage
from app.models import CONFIG_KEY, Config
from app.app_logging import stdout_print


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
    def __get___db_lockfile():
        db_path = ProjectDB.__get_db_path()
        if not db_path:
            return None

        __db_lock = FileLock(f"{db_path}.lock")
        return __db_lock


    @staticmethod
    def set_test_value(value: int):
        db_path: Final = ProjectDB.__get_db_path()
        lockfile: Final = ProjectDB.__get___db_lockfile()

        if db_path is None or lockfile is None:
            return

        with lockfile:
            db = TinyDB(db_path, storage=JSONStorage)
            stdout_print(db_path)
            q = Query()
            db.upsert({'key': 'value', 'value': value}, q.key == 'value')
