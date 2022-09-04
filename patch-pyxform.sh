#!/bin/bash
modulepath=$(python <<EOI
import pyxform
import os
print(os.path.dirname(pyxform.__file__))
EOI
)

echo $modulepath
patch -d $modulepath < pyxform-contact-types.patch 