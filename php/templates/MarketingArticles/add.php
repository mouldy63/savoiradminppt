<?php echo $this->Html->css('marketing.css',array('inline' => false));?>
<?php echo $this->Html->css('fabricStatus.css',array('inline' => false));?>

<h1>Add Article</h1>
<?php
echo $this->Form->create(null);
echo $this->Form->input('article_title',array('id'=>'ArticleHeader','div'=>false,'label'=>false,'class'=>'centertext',"placeholder"=>"Article Header"));
echo $this->Html->para(null,'<br>');
echo $this->Form->input('article_link',array('id'=>'ArticleLink','div'=>false,'label'=>false,'class'=>'centertext',"placeholder"=>"Article Link"));
echo $this->Form->end('Save MarketingArticle');
?>

