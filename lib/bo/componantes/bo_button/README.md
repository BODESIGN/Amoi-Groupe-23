> importation 
import '../bo/componantes/bo_button/bo_button.dart';

> declare
$BUTTON bt_seconnect = $BUTTON(text: 'Connect');

> update > function
funct() {
    print('simple function');
  }

bt_seconnect.setAction(funct);