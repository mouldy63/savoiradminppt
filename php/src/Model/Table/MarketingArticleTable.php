<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

//infers that this model will be used in PostsController
// tied to database table called posts
class MarketingArticleTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('marketing_articles');
        $this->setPrimaryKey('id');
        $this->hasOne('SavoirUser')->setForeignKey('user_id')->setJoinType('INNER')->setBindingKey('author_userid');
    }
}