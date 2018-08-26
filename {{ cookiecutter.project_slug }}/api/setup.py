import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="{{ cookiecutter.project_slug }}-api",
    version="0.0.1",
    author="Example Author",
    author_email="author@example.com",
    description="A small example package",
    long_description=long_description,
    long_description_content_type="text/markdown",
    packages=setuptools.find_packages(),
    entry_points={
        'console_scripts': [
            '{{ cookiecutter.project_slug }}-api = api.app:main'
            ]
        },
)
