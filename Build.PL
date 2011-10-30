#!/usr/bin/env perl

use Module::Build;

Module::Build->new(
    module_name        => 'Test::MockAlarm',
    license            => 'perl',
    dist_abstract      => 'Replace the alarm function with whatever you want',
    dist_author        => 'Jeremy Jack <jeremy@rocketscientry.com>',
    create_readme      => 1,
    create_makefile_pl => 'traditional',
    build_requires     => {
        'Test::More' => '0.98',
    },
)->create_build_script();
