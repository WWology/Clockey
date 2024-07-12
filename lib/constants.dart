const Map<String, String> gardenerMap = {
  'Nik': 'Nik',
  'Kit': 'Kit',
  'WW': 'WW',
  'Bonteng': 'Bonteng',
  'Sam': 'Sam',
};

int mapGardenerToId(String gardener) {
  switch (gardener) {
    case 'Nik':
      return 293360731867316225;
    case 'Kit':
      return 204923365205475329;
    case 'WW':
      return 754724309276164159;
    case 'Bonteng':
      return 172360818715918337;
    case 'Sam':
      return 332438787588227072;
    default:
      return 0;
  }
}
