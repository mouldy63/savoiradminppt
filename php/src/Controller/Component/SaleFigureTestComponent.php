<?php

namespace App\Controller\Component;

use Cake\ORM\TableRegistry;

class SaleFigureTestComponent extends \Cake\Controller\Component {

    public function isTestOn() {
        $saleFigureTest = TableRegistry::get('SaleFiguretest');
        $test = $saleFigureTest->find('all')->toArray();
        //echo var_dump($test);
        if (!empty($test) && count($test) > 0) {
            $testInfo['startTime'] = $test[0]['start_time'];
            $testInfo['endTime'] = $test[0]['end_time'];
            $testInfo['isTestOn'] = $test[0]['is_test_on'];
            $testInfo['id'] = $test[0]['sale_figure_test_id'];
            if ($testInfo['isTestOn'] == 'n') {
                return array('isTestOn' => false, 'testInfo' => $testInfo);
            } else {
                return array('isTestOn' => true, 'testInfo' => $testInfo);
            }
        } else {
            return array('isTestOn' => false, 'testInfo' => null);
        }
    }

}

?>