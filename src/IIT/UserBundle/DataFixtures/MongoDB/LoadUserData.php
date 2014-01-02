<?php
namespace IIT\UserBundle\DataFixtures\MongoDB;

use Doctrine\Common\DataFixtures\FixtureInterface;
use Doctrine\Common\Persistence\ObjectManager;
use IIT\UserBundle\Document\User;

class LoadUserData implements FixtureInterface
{
    /**
     * @var ObjectManager
     */
    private $manager;
    /**
     * @var string[] array of user names
     */
    private $users = array('user1', 'user2', 'user3');
    /**
     * {@inheritDoc}
     */
    public function load(ObjectManager $manager)
    {
        $this->manager = $manager;

        foreach ($this->users as $username) {
            $this->createUser($username);
        }
    }

    private function createUser($username)
    {
        $userAdmin = new User();
        $userAdmin->setUsername($username);
        $userAdmin->setEnabled(true);
        $userAdmin->setPlainPassword($username);

        $this->manager->persist($userAdmin);
        $this->manager->flush();
    }
}