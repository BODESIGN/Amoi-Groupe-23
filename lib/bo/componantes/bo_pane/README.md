> importation 
import '../bo/componantes/bo_pane/bo_pane.dart';

> declare
$PANE pane = $PANE(contenue: [
    const Text('Se connect'),
    const Text('New compte'),
  ]);

> update
setState(() => {pane.currentePage = 1});

> build
pane.build(),
