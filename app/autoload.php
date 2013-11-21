<?php

use Composer\Autoload\ClassLoader;
use Doctrine\Common\Annotations\AnnotationRegistry;
use Doctrine\ODM\MongoDB\Mapping\Driver\AnnotationDriver;

/**
 * @var ClassLoader $loader
 */
$loader = require __DIR__.'/../vendor/autoload.php';

AnnotationDriver::registerAnnotationClasses();
AnnotationRegistry::registerLoader(array($loader, 'loadClass'));

return $loader;
