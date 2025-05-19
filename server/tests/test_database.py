import pytest
from filelock import FileLock
from tinydb import TinyDB
from tinydb.storages import JSONStorage

from app.models.models import Config, CONFIG_KEY
from app.database.database import ConfigDB, ProjectDB  # adjust to your real module path


@pytest.fixture(autouse=True)
def isolate_db(tmp_path, monkeypatch):
    """
    Point ConfigDB.config_db_path (and its private lock) into tmp_path/db.json
    so each test runs in a clean temp directory. The databse is created automatically
    upon interacting with it
    """
    db_file = tmp_path / "db.json"
    monkeypatch.setattr(ConfigDB, 'config_db_path', db_file)

    lock = FileLock(str(db_file) + '.lock')
    monkeypatch.setattr(ConfigDB, '_db_lock', lock)
    return tmp_path


def test_get_project_config_empty():
    """
    Make sure that an empty databse does not return a configuration
    """
    assert ConfigDB.get_project_config() is None


def test_set_and_get_project_config_roundtrip(isolate_db):
    """
    Add a project config to the database and then get it back.
    """
    # first create a dummy project dir
    project_dir = isolate_db / "myproj"
    project_dir.mkdir()

    # set the config
    cfg = Config(project_path=str(project_dir))
    ConfigDB.set_project_config(cfg)

    # now get it back
    loaded = ConfigDB.get_project_config()
    assert isinstance(loaded, Config)
    assert loaded.key == CONFIG_KEY
    assert loaded.project_path == str(project_dir)


def test_get_project_config_multiple_raises(isolate_db):
    """
    Make sure that you cannot set put multiple configs in the database
    """
    # manually insert two records with the same CONFIG_KEY
    db = TinyDB(isolate_db / "db.json", storage=JSONStorage)
    db.insert({'key': CONFIG_KEY, 'project_path': 'one'})
    db.insert({'key': CONFIG_KEY, 'project_path': 'two'})
    db.close()

    with pytest.raises(Exception) as exc:
        ConfigDB.get_project_config()
    assert "More than one config" in str(exc.value)


def test_get_project_dir_and_images_dir(isolate_db):
    """
    Make sure no project or images dir exists until you create it.
    Then make sure that once its created you can get it back.
    """
    # no config => both return None
    assert ConfigDB.get_project_dir() is None
    assert ConfigDB.get_images_dir() is None

    # after setting config
    project_dir = isolate_db / "foo"
    images = project_dir / "images"
    images.mkdir(parents=True)

    ConfigDB.set_project_config(Config(project_path=str(project_dir)))

    assert ConfigDB.get_project_dir() == project_dir
    assert ConfigDB.get_images_dir() == images


def test_projectdb_internal_paths_and_locks_none_when_no_config():
    """
    Test that if you dont have a config the ProjectDB doesnt return anything
    """
    # without config, both internals return None
    assert ProjectDB._get_db_path() is None
    assert ProjectDB._get_db_lockfile() is None
    # set_images() does nothing (returns None)
    assert ProjectDB.set_images() is None


def test_projectdb_get_db_path_and_lockfile_after_config(isolate_db):
    """
    check that after setting configuration you can get the database path and
    the lockfile from the project database code
    """
    # configure a project dir
    project_dir = isolate_db / "proj2"
    project_dir.mkdir()
    ConfigDB.set_project_config(Config(project_path=str(project_dir)))

    # path should be proj2/project_db.json
    expected = project_dir / "project_db.json"
    assert ProjectDB._get_db_path() == expected

    lock = ProjectDB._get_db_lockfile()
    assert isinstance(lock, FileLock)
    # the lock file should sit next to the JSON
    assert lock.lock_file == str(expected) + '.lock'


def test_set_images_creates_empty_db_when_no_pngs(isolate_db):
    """
    Inserts the names of images that are inside the "images" directory
    into the project database.
    """
    # project without images => still creates an empty JSON db
    project_dir = isolate_db / "proj3"
    project_dir.mkdir()
    ConfigDB.set_project_config(Config(project_path=str(project_dir)))

    # images/ doesn't exist yet => returns None
    assert ProjectDB.set_images() is None
 
    db = TinyDB(project_dir / "project_db.json", storage=JSONStorage)
    assert db.all() == []
    db.close()


def test_set_images_inserts_only_non_thumbnail_pngs(isolate_db):
    """
    Creates some dummy image files and makes sure that only pngs that 
    dont start with thumbnail_ end up in the database. 
    """
    project_dir = isolate_db / "proj4"
    images = project_dir / "images"
    images.mkdir(parents=True)

    # create some dummy files
    (images / "a.png").write_text("x")
    (images / "thumbnail_a.png").write_text("x")
    (images / "thumbnail_b.png").write_text("y")
    (images / "c.png").write_text("z")
    (images / "thumbnail_c.png").write_text("z")
    (images / "d.tif").write_text("alpha")

    ConfigDB.set_project_config(Config(project_path=str(project_dir)))
    ProjectDB.set_images()

    db = TinyDB(project_dir / "project_db.json", storage=JSONStorage)
    data = db.all()
    names = [item['image_name'] for item in data]
    assert set(names) == {"a.png", "c.png"}
    # ensure thumbnail entries are skipped
    assert not any(n.startswith("thumbnail_") for n in names)
    db.close()


def test_get_images_with_no_images(isolate_db):
    project_dir = isolate_db / "proj5"
    images = project_dir / "images"
    images.mkdir(parents=True)

    ConfigDB.set_project_config(Config(project_path=str(project_dir)))
    assert ProjectDB.get_images() is None


def test_get_images(isolate_db):
    project_dir = isolate_db / "proj6"
    images_dir = project_dir / "images"
    images_dir.mkdir(parents=True)

    ConfigDB.set_project_config(Config(project_path=str(project_dir)))
    (images_dir / "a.png").write_text("x")
    (images_dir / "thumbnail_a.png").write_text("x")

    (images_dir / "thumbnail_b.png").write_text("y")
    (images_dir / "c.png").write_text("z")
    (images_dir / "thumbnail_c.png").write_text("z")
    (images_dir / "d.tif").write_text("alpha")

    ProjectDB.set_images()
    images = ProjectDB.get_images()
    assert images is not None

    names = [item.image_name for item in images]
    assert set(names) == {"a.png", "c.png"}

def test_get_image_paths(isolate_db):
    project_dir = isolate_db / "proj7"
    images_dir = project_dir / "images"
    images_dir.mkdir(parents=True)

    ConfigDB.set_project_config(Config(project_path=str(project_dir)))
    (images_dir / "a.png").write_text("x")
    (images_dir / "thumbnail_a.png").write_text("x")
    (images_dir / "thumbnail_b.png").write_text("y")
    (images_dir / "c.png").write_text("z")
    (images_dir / "thumbnail_c.png").write_text("z")
    (images_dir / "d.tif").write_text("alpha")
    ProjectDB.set_images()

    image_paths = ProjectDB.get_image_paths()

    assert image_paths is not None
    assert set(image_paths) == {(images_dir / "a.png"), (images_dir / "c.png")}


# TODO test that set images only adds images to teh database that dont
# alreaady exist and does not overwrite existing data that may already be there


 














