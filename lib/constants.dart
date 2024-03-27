const Map<String, String> gardenerMap = {
  'Nik': 'Nik',
  'Kit': 'Kit',
  'WW': 'WW',
  'Bonteng': 'Bonteng',
  'Sam': 'Sam',
  'Nin': 'Nin',
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

const int botSpamChannelId = 721391448812945480;
const int botStuffChannelId = 720994728937521193;

const String ogDotaUrl = 'https://liquipedia.net/dota2/OG';
const String ogCSUrl = 'https://liquipedia.net/counterstrike/OG';
const String ogRLUrl = 'https://liquipedia.net/rocketleague/OG';
