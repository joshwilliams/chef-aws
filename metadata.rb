maintainer        "CargoMetrics"
maintainer_email  "it@cargometrics.com"
license           "Foo"
description       "Customizing cookbook for handling encrypted AWS credentials"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.1.4"
recipe            "awsencrypted", "Encrypted AWS credential handling"
depends           "aws"
