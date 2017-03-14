# MODS Oxygen Framework

This repository contains the Dartmouth College Library's Oxygen XML Editor framework for validating and transforming bibliographic records in the [MODS schema](https://www.loc.gov/standards/mods/). (See Oxygen's tutorial on ["Document Type Associations"](https://www.oxygenxml.com/doc/versions/18.0/ug-editor/topics/dg-complex-customization-tutorial.html) for general information about frameworks.)

## Components

### `/schema`

- Modified XSD to restrict allowed values for certain elements and attributes
- Schematron to validate compliance with our [local MODS implementation](https://www.dartmouth.edu/~library/catmet/metadata_nonmarc/mods_docs/)

### `/xsl`

- Customized version of LC's MODS-to-MARCXML transformation
- Locally-written transformations to other schemas
- Utility transformations and custom functions

### `/templates`

- Record templates specific to various digital projects and format types

### `/resources`

- Application of Oxygen's content completion features to add our required sub-elements and attributes when a new top-level element is created

### `/css`

- CSS for an alternate view of a MODS document in Oxygen's "Author" mode

### Other

- `catalog.xml`, which allows resolution of LC XSD and XSL URLs to locally-stored versions for persistence

## License

Original content: Copyright 2014-2017 Trustees of Dartmouth College

Made available under the MIT License. For details, see [LICENSE](https://github.com/akhtars/mods-oxygen-framework/blob/master/LICENSE.txt).
