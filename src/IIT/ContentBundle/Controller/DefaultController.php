<?php

namespace IIT\ContentBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;

class DefaultController extends Controller
{
    /**
     * @Route("/")
     * @Template()
     */
    public function homepageAction()
    {
        return array();
    }
    /**
     * @Route("/list")
     * @Template()
     */
    public function listPageAction()
    {
        return array();
    }
    /**
     * @Route("/list{id}.html")
     * @Template()
     */
    public function listPageShowAction($id)
    {
        return array('id' => $id);
    }
}
