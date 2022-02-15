
<?php

function get_prospectus_hero_images($limit = -1, $shuffled = false) {

	$urls = array();

	$args = array(
		'post_type' => 'homepage_images',
		'post_status' => 'publish',
		'posts_per_page' => -1
	);
	$query = new WP_Query( $args );

	if($query->have_posts()) {
		while($query->have_posts()) {
			$query->the_post();

			// echo 'image';
			if(has_post_thumbnail()) {
                array_push($urls, get_the_post_thumbnail_url(get_the_ID(), 'full'));
            }

		}
	}
	wp_reset_query();

	if($shuffled) {
		shuffle($urls);
	}

	if ($limit > 0 && count($urls) > 0) {
	 	$urls = array_slice($urls, 0, min($limit, count($urls)));
	}
	

	return $urls;
}

function dudp_homepage_image_shortcode($atts) {
	$a = shortcode_atts(array(

	), $atts, 'get-post-details');

	$urls = get_prospectus_hero_images(9, false);

	var_dump($urls);
}



add_shortcode('dudp_homepage_image', 'dudp_homepage_image_shortcode');