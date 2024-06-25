<!-- File: /app/View/MarketingArticles/view.ctp -->

<h1><?php echo h($marketing_article['MarketingArticle']['article_title']); ?></h1>

<p><small>Created: <?php echo $post['MarketingArticle']['created']; ?></small></p>

<p><?php echo h($marketing_article['MarketingArticle']['article_link']); ?></p>