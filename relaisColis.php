<?php
/*
* 2007-2014 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2014 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*/

require('../../config/config.inc.php');
$relais = Db::getInstance()->getValue('SELECT c.id_carrier
													FROM `'._DB_PREFIX_.'carrier` as c, `'._DB_PREFIX_.'tnt_carrier_option` as o
													WHERE c.id_carrier = o.id_carrier
													AND o.option LIKE "%D%"
													AND c.external_module_name = "tntcarrier"
													AND c.deleted = "0" AND c.id_carrier = "'.(int)($_GET['id_carrier']).'"');

$tnt_carrier = Db::getInstance()->getValue('SELECT c.id_carrier
													FROM `'._DB_PREFIX_.'carrier` as c, `'._DB_PREFIX_.'tnt_carrier_option` as o
													WHERE c.id_carrier = o.id_carrier
													AND c.deleted = "0" AND o.id_carrier = "'.(int)($_GET['id_carrier']).'"');
$carrier_infos = Db::getInstance()->ExecuteS('SELECT *
													FROM `'._DB_PREFIX_.'carrier` as c,`'._DB_PREFIX_.'carrier_lang` as l
													WHERE c.id_carrier = l.id_carrier
													AND c.id_carrier = "'.(int)($_GET['id_carrier']).'"');

$tnt_carrier_option = Db::getInstance()->getValue('SELECT o.option
													FROM `'._DB_PREFIX_.'tnt_carrier_option` as o
													WHERE  o.id_carrier = "'.(int)($_GET['id_carrier']).'"');

?><input id="tntRCSelectedType" type="hidden" value="<?php echo $tnt_carrier_option; ?>"><?php

function phoneForm($mob, $tel)
{
	if ($tel != '06' && $mob != '06' && $tel != '07' && $mob != '07')
	{
		echo '<div id="mobilenumber" >';
		echo 'Afin d\'ameliorer les conditions de livraison, veuillez renseigner votre numero de mobile : <input type="mobile" name="mobileTnt" id="mobileTnt" onblur="postMobile(\''.Configuration::get('TNT_CARRIER_TOKEN').'\')"/>
		<input type="hidden" id="id_cart" value="'.Tools::safeOutput($_GET['idcart']).'"/>';
		echo '<hr />';
		echo '</div>';
		return true;
	}
	else
		return false;
}

$postcode = '';
if (isset($_GET['idcart']))
{
	$cartId = htmlentities($_GET['idcart']);
	$cart = new Cart($cartId);
	$address = new Address($cart->id_address_delivery);
	$postcode = $address->postcode;
}

$mob = substr($address->phone_mobile, 0, 2);
$tel = substr($address->phone, 0, 2);

if ($tnt_carrier !== false)
{

	if (version_compare(_PS_VERSION_, '1.6', '>='))
	{
		$description = $carrier_infos[0]['name'].' '.$carrier_infos[0]['delay'];

		echo '<h3 class="descr">'.$description.'</h3>';

		if ($relais !== false)
		{
			?>
			<input id="tntRCSelectedCode" type="hidden" value="">
			<input id="tntRCSelectedNom" type="hidden" value="">
			<input id="tntRCSelectedAdresse" type="hidden" value="">
			<input id="tntRCSelectedCodePostal" type="hidden" value="">
			<input id="tntRCSelectedCommune" type="hidden" value="">
			<div id="tntcp">
				<div><span class="choixrelais">Choisissez le Relais Colis<sup class="tntRCSup">&reg;</sup>qui vous convient, entrez le code postal : </span>
					<input id="tntRCInputCP" class="tntRCInput" type="text" value="<?php echo $postcode;?>" size="5" maxlength="5">
					 <button type="button" class="button" onclick="tntRCgetCommunes();">Ok</button><br/></div>
			</div>
			<div id="relaisColisResponse" style="width: 50%;"></div>
			<div id="map_canvas" class="exemplePresentation" ></div>
			<?php
		}

		phoneForm($mob, $tel);
	}
	else
	{
		phoneForm($mob, $tel);

		if ($relais !== false)
		{
			?>
			<input id="tntRCSelectedCode" type="hidden" value="">
			<input id="tntRCSelectedNom" type="hidden" value="">
			<input id="tntRCSelectedAdresse" type="hidden" value="">
			<input id="tntRCSelectedCodePostal" type="hidden" value="">
			<input id="tntRCSelectedCommune" type="hidden" value="">
			<h3>Choisissez le Relais Colis<sup class="tntRCSup">&reg;</sup>qui vous convient :</h3>
				<div class='tntchoixCP'><label>Entrez le code postal : </label><input id="tntRCInputCP" class="tntRCInput" type="text" value="<?php echo $postcode;?>" size="5" maxlength="5"> <button type="button" class="button" onclick="tntRCgetCommunes();">Ok</button></div><br/>
			<div id="relaisColisResponse" style="width: 50%;"></div>
			<div id="map_canvas" class="exemplePresentation"></div>
			<?php
		}
	}

}

?>
