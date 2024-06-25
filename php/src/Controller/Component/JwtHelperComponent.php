<?php
namespace App\Controller\Component;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

class JwtHelperComponent extends \Cake\Controller\Component {

	public function validateClientCredentials($params, $comreg) {
        $sentClientID = $params['client_id'];
        $sentClientSecret = $params['client_secret'];

        $clientID = $comreg->getComregVal('RESTSERVICECLIENTID');
        $clientSecret = $comreg->getComregVal('RESTSERVICECLIENTSECRET');
        
        return ($sentClientID === $clientID && $sentClientSecret === $clientSecret);
	}

	public function makeSugarJwt($comreg) {
        $clientID = $comreg->getComregVal('RESTSERVICECLIENTID');
        $clientSecret = $comreg->getComregVal('RESTSERVICECLIENTSECRET');
		$myDomain = $comreg->getComregVal('RESTSERVICEDOMAIN');
		$ttl = 3600;

		$payload = array(
			"iss" => $clientID,  // Issuer
			"sub" => $clientID,  // Subject
			"aud" => $myDomain, // Audience (the API server)
			"exp" => time() + $ttl, // Expiration time (1 hour)
			"iat" => time() // Issued at time
		);
		
		// Sign the payload with your client secret
		$jwt = JWT::encode($payload, $clientSecret, 'HS256');
        return $jwt;
	}

	public function validateSugarJwt($comreg) {
		//return true;
        $token = "";
		$clientID = $comreg->getComregVal('RESTSERVICECLIENTID');
		$clientSecret = $comreg->getComregVal('RESTSERVICECLIENTSECRET');
		$myDomain = $comreg->getComregVal('RESTSERVICEDOMAIN');
        $currentTimestamp = time();

        if (isset($_SERVER['HTTP_AUTHORIZATION'])) {
            $authorizationHeader = $_SERVER['HTTP_AUTHORIZATION'];
            $token = str_replace('Bearer ', '', $authorizationHeader);
        } else {
			return false;
        }

        try {
            $decoded = JWT::decode($token, $clientSecret, ['HS256']);
            if (
                $decoded->iss !== $clientID ||
                $decoded->sub !== $clientID ||
                $decoded->aud !== $myDomain ||
                $decoded->exp < $currentTimestamp
            ) {
				return false;
            }
        } catch (Exception $e) {
			return false;
        } catch(\Firebase\JWT\ExpiredException $e){
			return false;
        }
		return true;
	}
}

?>