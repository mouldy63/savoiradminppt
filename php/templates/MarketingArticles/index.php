<?php use Cake\Routing\Router; ?>
<?php use Cake\I18n\Time; ?>
<?php echo $this->Html->css('fabricStatus.css',array('inline' => false));?>
<?php echo $this->Html->css('marketing.css',array('inline' => false));?>
<div class="container">
    <?php if ($this->Security->userHasRole('ADMINISTRATOR')) { ?>
        <a><button class="button" onclick="functionShow()"> New  </button></a>
    <?php }  ?>
    <?php

    ?>
    <div id="newArticleForm">
        <?php
        echo $this->Form->create(null, array('url' => array('action' => 'add'))). "\r\n";
        echo $this->Html->para(null,'<br>', array());
        echo $this->Form->input('article_title',array('type' => 'text','size' => '100', 'maxlength' =>'100', 'id'=>'ArticleHeader','div'=>false,'label'=>false,'class'=>'centertext',"placeholder"=>"Article Header (100 char)", "autocomplete"=>"off"));
        echo $this->Html->para(null,'<br>', array());
        echo $this->Form->input('article_link',array('type' => 'url', 'size' => '100', 'pattern'=>'https?://.+', 'title'=>'Include http://', 'maxlength' =>'200', 'id'=>'ArticleLink', 'div'=>false,'label'=>false,'class'=>'centertext',"placeholder"=>"Article Link (200 char)", "autocomplete"=>"off"));
        echo $this->Html->para(null,'<br>', array());
        echo $this->Form->input('author_userid', array('id'=> 'AuthorId', 'type' => 'hidden', 'value'=>$uid));
        echo $this->Form->button('Cancel', array('type'=>'reset', 'id'=>'CancelNew', 'onclick'=>'clearNewForm()', 'class'=>'button'), array('inline' => false)). "\r\n";
        echo $this->Form->button('Save', array('type' => 'submit', 'id'=>'SaveNew','class'=>'button disabled'), array('inline' => false));
        echo $this->Form->end();
        ?>
    </div>

    <div id="Table">
        <table>
            <tr>
                <th>Article</th>
                <?php if ($this->Security->userHasRole('ADMINISTRATOR')) { ?>
                    <th>Action</th>
                <?php }?>
            </tr>

            <!-- Here is where we loop through our $MarketingArticles array, printing out marketing_article info -->
            <?php foreach ($marketing_articles as $marketing_article):

                $rowId = $marketing_article['id'];
                ?>

                <tr>
                    <td>
                        <span id="article_title-<?php echo $rowId; ?>">
                            <!-- articles-->
                            <?php echo $this->Html->link("<b>".
                                $this->Time->format($marketing_article['created'], 'dd MMM YYYY', 'invalid') .  " - " .
                                $marketing_article['article_title']."</b>"
                                . " <br/> ". $marketing_article['article_link']."<br/> "
                                . "<i>Edited: " .$this->Time->format($marketing_article['modified'], 'dd MMM YYYY HH:mm', 'invalid') . " by " . $marketing_article['savoir_user']['name'] . " (" . $marketing_article['savoir_user']['username'] . ")</i>",

                                $marketing_article['article_link'], //<the link it goes to

                                array(
                                    'rel' => 'noreferrer',
                                    'inline' => false,
                                    'escape' => false
                                )
                            ); ?>
                        </span>
                    </td>
                    <!-- actions -->
                    <td>
                        <!--                        --><?php
                        //                        echo $this->Html->link(
                        //                            'Edit',
                        //                            array('action' => 'edit', $marketing_article['id'])
                        //                        );
                        //                        ?>
                        <?php if ($this->Security->userHasRole('ADMINISTRATOR')) { ?>
                            <button class="button" onclick="window.location.href='<?php echo Router::url(array('controller'=>'MarketingArticles',
                                'action'=>'edit' . '/'. $marketing_article['id']), true)?>//'">Edit
                            </button>
                        <?php } ?>

                    </td>
                </tr>
            <?php endforeach; ?>
            <?php unset($marketing_article); ?>
        </table>
    </div>

</div>

<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="../../../common/jquery.js" type="text/javascript"></script>
<script>

    $("input").keyup(function() {
        if($('#ArticleHeader').val() != "" && $('#ArticleLink').val() != "") {
            $('#SaveNew').removeAttr('disabled');
            $('#SaveNew').removeClass('disabled')
        } else {
            $('#SaveNew').attr('disabled', true);
            $('#SaveNew').addClass('disabled')
        }
    });

    function functionShow() {
        $("#newArticleForm").show();
    }

    function clearNewForm(){
        $("#newArticleForm").hide();
        $("#AuthorId").val($uid); //need to set the id as the reset clears this from the form.
    }

</script>
