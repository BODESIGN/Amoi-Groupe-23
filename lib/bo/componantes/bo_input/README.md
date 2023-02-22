> importation 
import '../bo/componantes/bo_label/bo_input.dart';

> declare
$INPUT inputLogin = $INPUT(
  label: 'Login',
  width: 300,
  prefixIcon: Icons.person,
  color: Colors.yellow,
    isMotDePasse: false, // to true if Password
);

> update
funct() {
    print('simple function');
  }

inputLogin.setSuffixAction(funct);

> getValue
String login = inputLogin.getValue();