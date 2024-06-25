<?php

namespace App\Model\Entity;

use Cake\ORM\Entity;

/**
 * Customerservice Entity
 *
 * @property int $CSID
 * @property string $CSNumber
 * @property int $CompletedBy
 * @property \Cake\I18n\FrozenDate $DateDelivered
 * @property string $ProblemDesc
 * @property int $Photos
 * @property string $ActionTaken
 * @property string $PossibleSolution
 * @property string $Showroom
 * @property int $OrderNo
 * @property string $ItemDesc
 * @property \Cake\I18n\FrozenDate $FirstAwareDate
 * @property int $Video
 * @property \Cake\I18n\FrozenDate $VisitActionDate
 * @property int $IDLocation
 * @property int $IDRegion
 * @property \Cake\I18n\FrozenDate $dataentrydate
 * @property \Cake\I18n\FrozenDate $followupdate
 * @property string $csclosed
 * @property \Cake\I18n\FrozenDate $datecaseclosed
 * @property string $custname
 * @property string $anycomments
 * @property string $savoirstaffresolvingissue
 * @property string $closedcasenotes
 * @property string $closedby
 * @property float $replacementprice
 * @property int $ServiceCode
 */
class Customerservice extends Entity
{

    /**
     * Fields that can be mass assigned using newEntity() or patchEntity().
     *
     * Note that when '*' is set to true, this allows all unspecified fields to
     * be mass assigned. For security purposes, it is advised to set '*' to false
     * (or remove it), and explicitly make individual fields accessible as needed.
     *
     * @var array
     */
    protected $_accessible = [
        'CSNumber' => true,
        'CompletedBy' => true,
        'DateDelivered' => true,
        'ProblemDesc' => true,
        'Photos' => true,
        'ActionTaken' => true,
        'PossibleSolution' => true,
        'Showroom' => true,
        'OrderNo' => true,
        'ItemDesc' => true,
        'FirstAwareDate' => true,
        'Video' => true,
        'VisitActionDate' => true,
        'IDLocation' => true,
        'IDRegion' => true,
        'dataentrydate' => true,
        'followupdate' => true,
        'csclosed' => true,
        'datecaseclosed' => true,
        'custname' => true,
        'anycomments' => true,
        'savoirstaffresolvingissue' => true,
        'closedcasenotes' => true,
        'closedby' => true,
        'replacementprice' => true,
        'ServiceCode' => true
    ];

}
