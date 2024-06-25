<?php

namespace App\Controller;
use App\Controller\EmailServicesController;
use App\Controller\AppController;
use Cake\ORM\TableRegistry;
use \App\Controller\Component\UtilityComponent;
use \DateTime;
use Cake\Event\EventInterface;

/**
 * Customerservice Controller
 *
 * @property \App\Model\Table\CustomerserviceTable $Customerservice
 * @property \App\Model\Table\ServiceCodeTable $Servicecode
 * @method \App\Model\Entity\Customerservice[]|\Cake\Datasource\ResultSetInterface paginate($object = null, array $settings = [])
 */
class CustomerserviceController extends SecureAppController
{

    /**
     * Index method
     *
     * @return \Cake\Http\Response|void
     */
    public function initialize() : void {
        parent::initialize();
        $this->loadComponent('Paginator');
		$this->loadModel('Location');
    } 
    public function beforeRender(EventInterface $event) {
    	parent::beforeRender($event);
    	$builder = $this->viewBuilder();
    	$builder->addHelpers([
        	'AuxiliaryData'
        ]);
    }   
    public function index()
    {
        $this->viewBuilder()->setLayout('savoirdatatables');
        /* customer service list goes here */
        //$Customerservice = TableRegistry::get('Customerservice');
        $cstable = TableRegistry::get('Customerservice');
		$customerservices = $cstable->getOpenCases($this);
		//debug($customerservices);
		//die;
        $total = count($customerservices);
        
        //die;
        $this->set('customerservices', $customerservices);
        $this->set('total', $total);
    }

    /**
     * View method
     *
     * @param string|null $id Customerservice id.
     * @return \Cake\Http\Response|void
     * @throws \Cake\Datasource\Exception\RecordNotFoundException When record not found.
     */
    public function view($id = null)
    {
        $customerservice = $this->Customerservice->get($id, [
            'contain' => []
        ]);

        $this->set('customerservice', $customerservice);
    }

    /**
     * Add method
     *
     * @return \Cake\Http\Response|null Redirects on successful add, renders view otherwise.
     */
    public function add()
    {
        $this->viewBuilder()->setLayout('savoir');
		$query = $this->Location->find()->where(['idlocation' => $this->getCurrentUserLocationId()]);
		$address = null;
		foreach ($query as $row) {
			$address = $row;
		}
		$currentusername=$this->getCurrentUserName();
		$this->set('currentusername', $currentusername);
		$adminheading = $row['adminheading'];
        $customerservice = $this->Customerservice->newEntity([]);
		$customerservice->CSNumber = $this->Customerservice->generateNumber();
        $customerservice->Showroom = $adminheading;
		$customerservice->CompletedBy = $this->getCurrentUsersId();
		$customerservice->IDLocation = $this->getCurrentUserLocationId();
		$customerservice->IDRegion = $this->getCurrentUserRegionId();
		$customerservice->dataentrydate = date("Y-m-d");
		$count=0;
	
        if ($this->request->is('post')) {
            $uploadPath = WWW_ROOT . '../../produploads/';
            $customerservice = $this->Customerservice->patchEntity($customerservice, $this->request->getData());
            $customerservice->csclosed = 'n';
            $customerservice->CSNumber = $this->Customerservice->generateNumber();
            if ($this->Customerservice->save($customerservice)) {
                foreach ($this->request->getData()['pictures'] as $key => $picture) {
                	if ($picture->getSize() > 0) {
                        $uploadFile = sprintf('%spicture%s_%d.jpg', $uploadPath, $customerservice->CSNumber, $key);
                        $picture->moveTo($uploadFile);
                        $customerServiceUploadTable = TableRegistry::get('CustomerServiceUpload');
                        $customerServiceEntity = $customerServiceUploadTable->newEntity([]);
                        $customerServiceEntity->csid=$customerservice->CSID;
                        $customerServiceEntity->prodfilename=sprintf('%spicture%s_%d.jpg', '../../produploads/', $customerservice->CSNumber, $key);
                        $customerServiceEntity->dateuploaded = date("Y-m-d");
                        if ($customerServiceUploadTable->save($customerServiceEntity)) {
                            // The $article entity contains the id now
                            $id = $customerServiceEntity->id;
							$count += 1;
                        }
                    }
                }
				//$customerServiceEntity->DateDelivered = UtilityComponent::makeMysqlDateStringFromDisplayString($formData['DateDelivered']);
                $uploadFile = sprintf('%svideo_%s.mp4', $uploadPath, $customerservice->CSNumber);
                $video = $this->request->getData()['video'];
                if ($video->getSize() > 0) {
	                $video->moveTo($uploadFile);
                    $customerServiceUploadTable = TableRegistry::get('CustomerServiceUpload');
                    $customerServiceEntity = $customerServiceUploadTable->newEntity([]);
                    $customerServiceEntity->csid=$customerservice->CSID;
                    $customerServiceEntity->prodfilename=sprintf('%svideo_%s.mp4', '../../produploads/', $customerservice->CSNumber, $key);
                    $customerServiceEntity->dateuploaded = date("Y-m-d");
                    if ($customerServiceUploadTable->save($customerServiceEntity)) {
                        // The $article entity contains the id now
                        $id = $customerServiceEntity->id;
						$count += 1;
                    }
                }

                $this->Flash->success(__('The customerservice has been saved.'));
				
				$to='SavoirAdminCustomerService@savoirbeds.co.uk';
				$cc='';
				$from='noreply@savoirbeds.co.uk';
				$fromName='';
				$subject=$this->request->getData()['OrderNo'].' - Customer Service form completed';
				$content = "<html><body><font face='Arial, Helvetica, sans-serif'><b>CUSTOMER SERVICE</b><br /><table width='98%' border='1'  cellpadding='3' cellspacing='0'>";
				$content .= "<tr><td>Customer Service Number & Date</td><td>" .$customerservice->CSNumber ." - " .date("d-m-Y"). "</td></tr>";
				$content .= "<tr><td>Form Completed by:</td><td>" .$currentusername. "</td></tr>";
				$content .= "<tr><td>Date item delivered to Customer</td><td>" .$this->request->getData()['DateDeliveredD']. "</td></tr>";
				$content .= "<tr><td>Please describe the problem with the product</td><td>" .$this->request->getData()['ProblemDesc']. "</td></tr>";
				$content .= "<tr><td>Showroom</td><td>".$this->request->getData()['Showroom']."</td></tr>";
				$content .= "<tr><td>Customer Name</td><td>".$this->request->getData()['custname']."</td></tr>";
				$content .= "<tr><td>Order No</td><td>".$this->request->getData()['OrderNo']."</td></tr>";
				$content .= "<tr><td>Item Description</td><td>".$this->request->getData()['ItemDesc']."</td></tr>";
				$content .= "<tr><td>Date customer first made you aware of the problem</td><td>".$this->request->getData()['FirstAwareD']."</td></tr>";
				$content .= "<tr><td>Please let us know what you feel the solution to the problem is:</td><td>".$this->request->getData()['PossibleSolution']."</td></tr>";
				$content .= "<tr><td>What action have you already taken about this problem:</td><td>".$this->request->getData()['ActionTaken']."</td></tr>";
				$content .= "<tr><td>What date was this visit/ action:</td><td>".$this->request->getData()['actiondateD']."</td></tr>";
				$content .= "<tr><td>Any other comments:</td><td>".$this->request->getData()['anycomments']."</td></tr>";
				$content .= "<tr><td>No. of documents uploaded</td><td>".$count."</td></tr>";
				$content .= "</table></font></body></html";
				
				$emailServices = new EmailServicesController;
				$emailServices->generateBatchEmail($to, $cc, $from, $fromName, $subject, $content, 'html', null);

                return $this->redirect(['action' => 'add']);
            }
            //var_dump($customerservice->getErrors());
            $this->Flash->error(__('The customerservice could not be saved. Please, try again.'));
        }
		
		
		
        $this->set(compact('customerservice'));
    }

    public function test()
    {
        var_dump($this->Customerservice->generateNumber());
    }

    /**
     * Delete method
     *
     * @param string|null $id Customerservice id.
     * @return \Cake\Http\Response|null Redirects to index.
     * @throws \Cake\Datasource\Exception\RecordNotFoundException When record not found.
     */
    public function delete($id = null)
    {
        $this->request->allowMethod(['post', 'delete']);
        $customerservice = $this->Customerservice->get($id);
        if ($this->Customerservice->delete($customerservice)) {
            $this->Flash->success(__('The customerservice has been deleted.'));
        } else {
            $this->Flash->error(__('The customerservice could not be deleted. Please, try again.'));
        }

        return $this->redirect(['action' => 'index']);
    }
    /**
     * Report method
     *
     * @return \Cake\Http\Response|void
     */

    public function report() {
    	$this->viewBuilder()->setLayout('fabricstatus');
        $csid = $this->request->getQuery('csid');
        //$Customerservice = TableRegistry::get('Customerservice');
        $query = $this->Customerservice->find();
        $query = $query->where(['CSID =' => $csid]);
        $query = $query->contain(["CustomerServiceNotes"=>["SavoirUser"],"Purchase", "SavoirUser", "CustomerServiceUpload"]);
        //debug($query);
        $customerservice = $query->first();
        //debug($customerservice);
        //die;
        if ($this->request->is('post')) {
            $uploadPath = WWW_ROOT . '../../produploads/';
            //var_dump($this->request->getData());
            
            
            
            //$customerservice->csclosed = 'n';
            
            $customerservice = $this->Customerservice->patchEntity($customerservice, $this->request->getData());
            $customerserviceFollowup = \DateTime::createFromFormat('d/m/Y', $this->request->getData()["followupdate"]);
            
            $userID=$this->SavoirSecurity->getCurrentUsersId();
            if ($customerserviceFollowup != false) {
                $customerservice->followupdate = $customerserviceFollowup->format('Y-m-d');
            } else {
                $customerservice->followupdate = null;
            }
            if ($customerservice->csclosed == 'y') {
                if ($customerserviceFollowup != false) {
                    $customerservice->datecaseclosed = $customerserviceFollowup->format('Y-m-d');
                } else {
                    $customerservice->datecaseclosed = date('Y-m-d');
                }
				
               // $customerservice->datecaseclosed = $customerserviceFollowup->format('Y-m-d');     
            } else {
                $customerservice->csclosed = 'n';
            }
			if ($this->request->getData()["sizes"] != 'n') {
				$customerservice->ServiceCode = $this->request->getData()["sizes"];
			}
            //var_dump($this->request->getData()['pictures']);
            if ($this->Customerservice->save($customerservice)) {
                foreach ($this->request->getData()['pictures'] as $key => $picture) {
                    if ($picture->getSize() > 0) {
                        $uploadFile = sprintf('%spicture%s_%d.jpg', $uploadPath, $customerservice->CSNumber, $key);
                        $picture->moveTo($uploadFile);
                        $customerServiceUploadTable = TableRegistry::get('CustomerServiceUpload');
                        $customerServiceEntity = $customerServiceUploadTable->newEntity([]);
                        $customerServiceEntity->csid=$customerservice->CSID;
                        $customerServiceEntity->prodfilename=sprintf('%spicture%s_%d.jpg', '../../produploads/', $customerservice->CSNumber, $key);
                        $customerServiceEntity->dateuploaded = date("Y-m-d");
                        if ($customerServiceUploadTable->save($customerServiceEntity)) {
                            // The $article entity contains the id now
                            $id = $customerServiceEntity->id;
                        }
                    }
                }
                //insert note
                if ($this->request->getData()["note"] != '') {
                    $customerServiceNotesTable = TableRegistry::get('CustomerServiceNotes');
                    $customerServiceNotesEntity = $customerServiceNotesTable->newEntity([]); 
                    $customerServiceNotesEntity->csid=$customerservice->CSID;
                    $customerServiceNotesEntity->note=$this->request->getData()["note"];
                    $customerServiceNotesEntity->dateadded = date("Y-m-d");
                    $customerServiceNotesEntity->actiondate = $customerservice->followupdate;
                    $customerServiceNotesEntity->noteaddedby = $userID;
                    if ($customerServiceNotesTable->save($customerServiceNotesEntity)) {
                        // The $article entity contains the id now
                        $id = $customerServiceNotesEntity->id;
                    }
                    //var_dump($customerServiceNotesEntity->getErrors());
                }

                //$uploadFile = sprintf('%svideo_%s.mp4', $uploadPath, $customerservice->CSID);
                //move_uploaded_file($this->request->getData()['video']['tmp_name'], $uploadFile);
                $this->Flash->success(__('The customerservice has been saved.'));
                
                return $this->redirect(['action' => 'index']);
            }
            var_dump($customerservice->getErrors());
            $this->Flash->error(__('The customerservice could not be saved. Please, try again.'));
        }
        
        $Servicecode = TableRegistry::get('Servicecode');
        $queryserviceCode = $Servicecode->find('all');
        $row_options_servicecode = array();
        $row_options_servicecode[0] = array('text' => "Please choose code", 'value' => "n");
        foreach($queryserviceCode->toArray() as $key => $val){

            $row_options_servicecode[$val['servicecodeID']] = array('text' => $val['ServiceCode'], 'value' => $val['servicecodeID']);
        }
		
        //var_dump ($customerservice);
        $this->set(compact('customerservice', 'row_options_servicecode'));
    }
	
	public function closedreport() {
    	$this->viewBuilder()->setLayout('fabricstatus');
        $csid = $this->request->getQuery('csid');
        //$Customerservice = TableRegistry::get('Customerservice');
        $query = $this->Customerservice->find();
        $query = $query->where(['CSID =' => $csid]);
        $query = $query->contain(["CustomerServiceNotes"=>["SavoirUser"],"Purchase", "SavoirUser", "CustomerServiceUpload"]);
        //debug($query);
        $customerservice = $query->first();
        //debug($customerservice);
        //die;
        if ($this->request->is('post')) {
            $uploadPath = WWW_ROOT . '../../produploads/';
            //var_dump($this->request->getData());
            
            
            
            //$customerservice->csclosed = 'n';
            
            $customerservice = $this->Customerservice->patchEntity($customerservice, $this->request->getData());
            $customerserviceFollowup = \DateTime::createFromFormat('d/m/Y', $this->request->getData()["followupdate"]);
            
            $userID=$this->SavoirSecurity->getCurrentUsersId();
            if ($customerserviceFollowup != false) {
                $customerservice->followupdate = $customerserviceFollowup->format('Y-m-d');
            } else {
                $customerservice->followupdate = null;
            }
            if ($customerservice->csclosed == 'y') {
                if ($customerserviceFollowup != false) {
                    $customerservice->datecaseclosed = $customerserviceFollowup->format('Y-m-d');
                } else {
                    $customerservice->datecaseclosed = date('Y-m-d');
                }
				$customerservice->ServiceCode = $customerservice->servicecode;
               // $customerservice->datecaseclosed = $customerserviceFollowup->format('Y-m-d');     
            } else {
                $customerservice->csclosed = 'n';
            }
            //var_dump($this->request->getData()['pictures']);
            if ($this->Customerservice->save($customerservice)) {
                foreach ($this->request->getData()['pictures'] as $key => $picture) {
                	if ($picture->getSize() > 0) {
                    	$uploadFile = sprintf('%spicture%s_%d.jpg', $uploadPath, $customerservice->CSNumber, $key);
                    	$picture->moveTo($uploadFile);
                        $customerServiceUploadTable = TableRegistry::get('CustomerServiceUpload');
                        $customerServiceEntity = $customerServiceUploadTable->newEntity([]);
                        $customerServiceEntity->csid=$customerservice->CSID;
                        $customerServiceEntity->prodfilename=sprintf('%spicture%s_%d.jpg', '../../produploads/', $customerservice->CSNumber, $key);
                        $customerServiceEntity->dateuploaded = date("Y-m-d");
                        if ($customerServiceUploadTable->save($customerServiceEntity)) {
                            // The $article entity contains the id now
                            $id = $customerServiceEntity->id;
                        }
                    }
                }
                //insert note
                if (isset ($this->request->getData()["note"])) {
                    $customerServiceNotesTable = TableRegistry::get('CustomerServiceNotes');
                    $customerServiceNotesEntity = $customerServiceNotesTable->newEntity([]); 
                    $customerServiceNotesEntity->csid=$customerservice->CSID;
                    $customerServiceNotesEntity->note=$this->request->getData()["note"];
                    $customerServiceNotesEntity->dateadded = date("Y-m-d");
                    $customerServiceNotesEntity->actiondate = $customerservice->followupdate;
                    $customerServiceNotesEntity->noteaddedby = $userID;
                    if ($customerServiceNotesTable->save($customerServiceNotesEntity)) {
                        // The $article entity contains the id now
                        $id = $customerServiceNotesEntity->id;
                    }
                    //var_dump($customerServiceNotesEntity->getErrors());
                }

                //$uploadFile = sprintf('%svideo_%s.mp4', $uploadPath, $customerservice->CSID);
                //move_uploaded_file($this->request->getData()['video']['tmp_name'], $uploadFile);
                $this->Flash->success(__('The customerservice has been saved.'));
                
                return $this->redirect(['action' => 'index']);
            }
            //var_dump($customerservice->getErrors());
            $this->Flash->error(__('The customerservice could not be saved. Please, try again.'));
        }
        
        $Servicecode = TableRegistry::get('Servicecode');
        $queryserviceCode = $Servicecode->find('all');
        $row_options_servicecode = array();
        $row_options_servicecode[0] = array('text' => "Please choose code", 'value' => "n");
        foreach($queryserviceCode->toArray() as $key => $val){

            $row_options_servicecode[$val['servicecodeID']] = array('text' => $val['ServiceCode'], 'value' => $val['servicecodeID']);
        }
        //var_dump ($customerservice);
        $this->set(compact('customerservice', 'row_options_servicecode'));
    }

    protected function _getAllowedRoles(){
        return array("ADMINISTRATOR","SALES");
    }
}
