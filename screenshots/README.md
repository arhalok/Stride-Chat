## Screenshots viewer

The screenshots in German are getting generated on a regular basis, each time there is a sync with Localazy. The English
screenshots are loaded from `../tests/uitests/src/test/snapshots/images`.

Because the gallery uses JavaScript modules, open it over HTTP rather than as a `file://` page. From the repository root, run:

```bash
python3 -m http.server 8000 --bind 127.0.0.1
```

Then open <http://127.0.0.1:8000/screenshots/>. Stop the server with `Ctrl+C` when finished.

## Generate screenshots for other languages

Generating screenshots for other languages can be done locally. Here are the steps to follow:

- Run the script [generateAllScreenshots.py](../tools/test/generateAllScreenshots.py) with the languages as parameters to generate the screenshots for the new languages. This will not delete the
  existing screenshots, but will add new ones for the new languages. This will also update the Javascript data. For instance, to generate screenshots for French and Spanish, run the following command in a terminal:

```bash
generateAllScreenshots.py fr es
```

- Open the page `index.html` in a browser to see the new screenshots.
