s3diff
======

Compare a local directory with its back-up on Amazon S3.

The script just shows the differences. It does neither change the content on S3 nor the local content.

Requirements
------------

The script was developed on Ubuntu. To install the AWS SDK for Ruby, do the following:

    sudo apt-get install libxslt-dev libxml2-dev
    sudo gem install aws-sdk

To configure the AWS keys, create a file `config.yml` with the following content:

    access_key_id: AKIAIOSFODNN7EXAMPLE
    secret_access_key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

The file `config.yml` must be in the same directory as the `s3diff.rb` script.

Usage
-----

The script is run as follows:

    s3diff.rb /local/path s3://bucket/path
