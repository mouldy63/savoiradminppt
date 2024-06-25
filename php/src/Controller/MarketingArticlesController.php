<?php

namespace App\Controller;
use Cake\ORM\TableRegistry;

class MarketingArticlesController extends SecureAppController  {
    private $marketingArticle;
    public function initialize() : void {
        parent::initialize();
		$this->loadComponent('Flash');
		$this->loadComponent('RequestHandler');
		$this->loadModel('SavoirUser');
        $this->marketingArticle = TableRegistry::get('MarketingArticle');
        $this->viewBuilder()->addHelpers(['Html', 'Form', 'Flash']);
    }

    public function index() {
        $this->viewBuilder()->setLayout('fabricstatus');
        $this->set('uid',  $this->SavoirSecurity->getCurrentUsersId());
        $marketingArticles = $this->marketingArticle->find('all', array('order'=>'MarketingArticle.modified DESC'))->contain(['SavoirUser']);
        $this->set('marketing_articles', $marketingArticles->toArray());
        $this->autoRender = true;
    }

    public function view($id = null) {
        if (!$id) {
            throw new NotFoundException(__('Invalid marketing_article'));
        }

        $marketing_article = $this->marketingArticle->findById($id);
        if (!$marketing_article) {
            throw new NotFoundException(__('Invalid marketing_article'));
        }
        $this->set('marketing_article', $marketing_article);
    }

    public function add() {
        if ($this->request->is('post')) {
            $article = $this->marketingArticle->newEntity([]);
            //debug($this->request->getData());
            $article->set($this->request->getData());
            $article->created = time();
            $article->modified = time();
            if ($this->marketingArticle->save($article)) {
                $this->Flash->success(__('Your marketing article has been saved.'));
                return $this->redirect(array('action' => 'index'));
            }
            $this->Flash->error(__('Unable to add your marketing article.'));
        }
    }

    public function edit($id = null) {
        $this->set('uid', $this->SavoirSecurity->getCurrentUsersId());
        if (!$id) {
            throw new NotFoundException(__('Invalid marketing_article'));
        }

        $marketing_article = $this->marketingArticle->get($id);

        if (!$marketing_article) {
            throw new NotFoundException(__('Invalid marketing_article'));
        }

        if ($this->request->is('post')) {
            $marketing_article->set($this->request->getData());
            $marketing_article->id = $id;
            $marketing_article->modified = time();
            if ($this->marketingArticle->save($marketing_article)) {
                $this->Flash->success(__('Your marketing article has been updated.'));
                return $this->redirect(array('action' => 'index'));
            }
            $this->Flash->error(__('Unable to update your marketing article.'));
        } else if ($this->request->is('get')) {
            $this->set('marketing_article', $marketing_article);
        }

        //if (!$this->request->getData()) {
        //    $this->request->setData($marketing_article);
        //}

        $this->viewBuilder()->setLayout('fabricstatus');
    }

    public function delete($id) {
        if ($this->request->is('get')) {
            throw new MethodNotAllowedException();
        }

        if ($this->marketingArticle->delete($id)) {
            $this->Flash->success(
                __('The marketing_article with id: {0} has been deleted.', h($id))
            );
        } else {
            $this->Flash->error(
                __('The marketing_article with id: {0} could not be deleted.', h($id))
            );
        }

        return $this->redirect(array('action' => 'index'));
    }

    protected function _getAllowedRoles(){
        return ["ADMINISTRATOR","ONLINE_SHOWROOM"];
    }

    protected function _getAllowedRegions(){
        return [["London"], "OR"];
    }
}
