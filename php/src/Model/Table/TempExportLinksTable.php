<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class TempExportLinksTable extends AbstractExportLinksTable {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('temp_exportlinks');
        $this->setPrimaryKey('exportLinksID');
        $this->belongsTo('ExportCollShowroom')->setForeignKey('LinksCollectionID')->setJoinType('LEFT')->setBindingKey('exportCollshowroomsID');
        $this->belongsTo('Purchase')->setForeignKey('purchase_no')->setJoinType('LEFT')->setBindingKey('purchase_No');
    }

    public function getExportLinksForExportcollectionsID($exportcollectionsID, $pn) {
    	$conn = ConnectionManager::get('default');
        $sql = "Select exportLinksID from exportlinks l join exportcollshowrooms c on l.LinksCollectionID = c.exportCollshowroomsID join exportcollections e on e.exportCollectionsID=c.exportCollectionID where e.exportcollectionsID = :exportcollectionsID and l.purchase_no = :pn";
		return $conn->execute($sql, ['pn' => $pn, 'exportcollectionsID' => $exportcollectionsID])->fetchAll('assoc');
    }

}
?>