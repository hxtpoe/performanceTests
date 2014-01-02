<?php

namespace IIT\ContentBundle\Tests\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class SecurityControllerTest extends WebTestCase
{
    /**
     * @test
     */
    public function userLoginWithInvalidCredentials()
    {
        $client = static::createClient();

        $crawler = $client->request('GET', '/login');

        $form = $crawler->selectButton('Login')->form();

        $client->submit(
            $form,
            array(
                '_username' => 'user1',
                '_password' => 'invalidPassword'
            )
        );

        $client->followRedirect();

        $this->assertRegExp(
            '/Invalid username or password/',
            $client->getResponse()->getContent()
        );
    }
    /**
     * @test
     */
    public function userLoginWithValidCredentials()
    {
        $client = static::createClient();

        $crawler = $client->request('GET', '/login');

        $form = $crawler->selectButton('Login')->form();

        $client->submit(
            $form,
            array(
                '_username' => 'user1',
                '_password' => 'user1'
            )
        );

        $client->request('GET', '/secured/index.html');

        $this->assertRegExp(
            '/Secured area!/',
            $client->getResponse()->getContent()
        );
    }
}
