<?php

namespace IIT\ContentBundle\Tests\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class DefaultControllerTest extends WebTestCase
{
    public function testHomepage()
    {
        $client = static::createClient();
        $crawler = $client->request('GET', '/');

        $this->assertTrue($client->getResponse()->isSuccessful()); // is 2xx?
        $this->assertEquals(1, $crawler->filter('h1')->count()); // does contain h1
        $this->assertRegExp(
            '/Lorem ipsum dolor sit amet/',
            $client->getResponse()->getContent()
        ); // is h1's value equal?
    }
}
