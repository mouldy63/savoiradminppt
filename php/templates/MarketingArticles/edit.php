<?php use Cake\Routing\Router; ?>
<?php echo $this->Html->css('marketing.css',array('inline' => false));?>
<?php echo $this->Html->css('fabricStatus.css',array('inline' => false));?>

<div class="container">
    <h1>Edit Marketing Article</h1>
    <?php

    echo $this->Form->create(null);
    echo $this->Form->input('article_title', array('type' => 'text', 'value'=>$marketing_article['article_title'], 'size' => '100', 'maxlength' =>'100', 'id'=>'ArticleHeader',"placeholder"=>"Article Header (100 char)", 'class'=>'centertext', "autocomplete"=>"off"));
    echo $this->Form->input('article_link', array( 'type' => 'url', 'value'=>$marketing_article['article_link'], 'size' => '100', 'maxlength' =>'200', 'id'=>'ArticleLink',"placeholder"=>"Article Link (200 char)", 'class'=>'centertext', "autocomplete"=>"off"));
    echo $this->Form->input('id', array('type' => 'hidden'));
    echo $this->Form->input('author_userid', array('type' => 'hidden', 'value'=>$uid));
    echo $this->Form->button('Save', array('type' => 'submit', 'class'=>'button disabled', 'id'=>'SaveEdit'), array('inline' => true));
    //echo "\r\n";?>


    <?php
    echo $this->Form->end();

    ?>
    <button class='button' onclick="window.location.href='<?php echo Router::url(['controller'=>'MarketingArticles',
        'action'=>'index' ], true)?>'">Cancel</button>
</div>

<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script>
    $("input").keyup(function() {
        if($('#ArticleHeader').val() != "" && $('#ArticleLink').val() != "") {
            $('#SaveEdit').removeAttr('disabled');
            $('#SaveEdit').removeClass('disabled')
        } else {
            $('#SaveEdit').attr('disabled', true);
            $('#SaveEdit').addClass('disabled')
        }
    });
</script>
