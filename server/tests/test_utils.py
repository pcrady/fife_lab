import pytest

from app.utils.image_utils import ImageUtils

@pytest.fixture(autouse=True)
def isolate_db(tmp_path):
    """
    create a temp directory to do work in
    """
    return tmp_path


def 


