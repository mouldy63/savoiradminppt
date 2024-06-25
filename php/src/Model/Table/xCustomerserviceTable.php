<?php
declare(strict_types=1);
namespace App\Model\Table;

use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

/**
 * Customerservice Model
 *
 * @method \App\Model\Entity\Customerservice get($primaryKey, $options = [])
 * @method \App\Model\Entity\Customerservice newEntity($data = null, array $options = [])
 * @method \App\Model\Entity\Customerservice[] newEntities(array $data, array $options = [])
 * @method \App\Model\Entity\Customerservice|bool save(\Cake\Datasource\EntityInterface $entity, $options = [])
 * @method \App\Model\Entity\Customerservice patchEntity(\Cake\Datasource\EntityInterface $entity, array $data, array $options = [])
 * @method \App\Model\Entity\Customerservice[] patchEntities($entities, array $data, array $options = [])
 * @method \App\Model\Entity\Customerservice findOrCreate($search, callable $callback = null, $options = [])
 */
class CustomerserviceTable extends Table
{

    /**
     * Initialize method
     *
     * @param array $config The configuration for the Table.
     * @return void
     */
    public function initialize(array $config) : void {
        parent::initialize($config);

        $this->setTable('customerservice');
        $this->setDisplayField('CSID');
        $this->setPrimaryKey('CSID');
        $this->hasMany('CustomerServiceNotes', ['order'=>'dateadded desc'])->setForeignKey('csid')->setJoinType('LEFT')->setBindingKey('CSID');
        $this->belongsTo('Purchase')->setForeignKey('orderno')->setJoinType('LEFT')->setBindingKey('ORDER_NUMBER');
        $this->hasOne('ServiceCode')->setForeignKey('ServiceCodeID')->setJoinType('LEFT')->setBindingKey('ServiceCode');
        $this->hasMany('CustomerServiceUpload')->setForeignKey('csid')->setJoinType('LEFT')->setBindingKey('CSID');
        $this->belongsTo('SavoirUser')->setForeignKey('completedBy')->setJoinType('LEFT')->setBindingKey('user_id');
    }

    /**
     * Default validation rules.
     *
     * @param \Cake\Validation\Validator $validator Validator instance.
     * @return \Cake\Validation\Validator
     */
    public function validationDefault(Validator $validator) : Validator
    {
        $validator
                ->integer('CSID')
                ->allowEmptyString('CSID', Validator::WHEN_CREATE);

        $validator
                ->scalar('CSNumber')
                ->maxLength('CSNumber', 15)
                ->allowEmptyString('CSNumber');

        $validator
                ->integer('CompletedBy')
                ->allowEmptyString('CompletedBy');

        $validator
                ->date('DateDelivered')
                ->allowEmptyDate('DateDelivered');

        $validator
                ->scalar('ProblemDesc')
                ->maxLength('ProblemDesc', 4294967295)
                ->notEmptyString('ProblemDesc');

        $validator
                ->allowEmptyString('Photos');

        $validator
                ->scalar('ActionTaken')
                ->maxLength('ActionTaken', 4294967295)
                ->allowEmptyString('ActionTaken');

        $validator
                ->scalar('PossibleSolution')
                ->maxLength('PossibleSolution', 4294967295)
                ->allowEmptyString('PossibleSolution');

        $validator
                ->scalar('Showroom')
                ->maxLength('Showroom', 255)
                ->allowEmptyString('Showroom');

        $validator
                ->integer('OrderNo')
                ->allowEmptyString('OrderNo');

        $validator
                ->scalar('ItemDesc')
                ->maxLength('ItemDesc', 4294967295)
                ->notEmptyString('ItemDesc');

        $validator
                ->scalar('FirstAwareD')
                ->notEmptyString('FirstAwareD');
				
		$validator
                ->date('FirstAwareDate')
                ->notEmptyDate('FirstAwareDate');

        $validator
                ->integer('Video')
                ->allowEmptyString('Video');

        $validator
                ->date('VisitActionDate')
                ->allowEmptyString('VisitActionDate');

        $validator
                ->integer('IDLocation')
                ->allowEmptyString('IDLocation');

        $validator
                ->integer('IDRegion')
                ->allowEmptyString('IDRegion');

        $validator
                ->date('dataentrydate')
                ->allowEmptyDate('dataentrydate');

        $validator
                ->date('followupdate')
                ->allowEmptyDate('followupdate');

        $validator
                ->scalar('csclosed')
                ->maxLength('csclosed', 1)
                ->requirePresence('csclosed', 'create')
                ->notEmptyString('csclosed');

        $validator
                ->date('datecaseclosed')
                ->allowEmptyDate('datecaseclosed');

        $validator
                ->scalar('custname')
                ->maxLength('custname', 255)
                ->allowEmptyString('custname');

        $validator
                ->scalar('anycomments')
                ->maxLength('anycomments', 4294967295)
                ->allowEmptyString('anycomments');

        $validator
                ->scalar('savoirstaffresolvingissue')
                ->maxLength('savoirstaffresolvingissue', 255)
                ->allowEmptyString('savoirstaffresolvingissue');

        $validator
                ->scalar('closedcasenotes')
                ->maxLength('closedcasenotes', 4294967295)
                ->allowEmptyString('closedcasenotes');

        $validator
                ->scalar('closedby')
                ->maxLength('closedby', 255)
                ->allowEmptyString('closedby');

        $validator
                ->decimal('replacementprice')
                ->allowEmptyString('replacementprice');

        $validator
                ->integer('ServiceCode')
                ->allowEmptyString('ServiceCode');

        return $validator;
    }

    public function generateNumber()
    {
        $lastData = $this->find('all', [
                    'conditions' => ['Customerservice.CSNumber LIKE' => date('ym-') . '%'],
                    'order' => ['Customerservice.CSNumber' => 'DESC']
                ])->first();
        $number = 1;
        //var_dump ($lastData->CSNumber);

        if ($lastData !== null) {
            $tmp = str_replace(date('ym-'), '', $lastData->CSNumber);
            $number = ($tmp + 1);
        }
        return date('ym-') . str_pad(strval($number), 3, '0', STR_PAD_LEFT);
    }

}
