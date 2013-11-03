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
    public function testListPage()
    {
        $client = static::createClient();
        $crawler = $client->request('GET', '/list');
        $this->assertTrue($client->getResponse()->isSuccessful()); // is 2xx?
        $links = $crawler->filter('a');
        $this->assertEquals(3, $links->count()); // does contain 3 links?
    }
    public function testListPageShow()
    {
        $singleTest = function($id) {
            $client = static::createClient();
            $crawler = $client->request('GET', '/list'.$id.'.html');
            $this->assertTrue($client->getResponse()->isSuccessful()); // is 2xx?
            $header = $crawler->filter('h1');
            $this->assertEquals('List '.$id, $header->text()); // does contain 3 links?
        };

        for ($i = 1; $i <= 3; $i++) {
            $singleTest($i);
        }
    }
}
