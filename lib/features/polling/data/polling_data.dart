import '../domain/polling_models.dart';

class PollingData {
  static const List<VotingInstruction> instructions = [
    VotingInstruction(
      step: '01',
      title: 'Bring Your PVC',
      description:
          'You must present your Permanent Voter Card (PVC) at the polling unit. No PVC, no vote.',
    ),
    VotingInstruction(
      step: '02',
      title: 'Join the Queue',
      description:
          'Arrive early and join the accreditation queue. INEC officials will verify your biometric data.',
    ),
    VotingInstruction(
      step: '03',
      title: 'Get Accredited',
      description:
          'A BVAS machine will scan your fingerprint to confirm your identity and eligibility.',
    ),
    VotingInstruction(
      step: '04',
      title: 'Collect Your Ballot',
      description:
          'After accreditation, collect your ballot paper from the Presiding Officer.',
    ),
    VotingInstruction(
      step: '05',
      title: 'Cast Your Vote',
      description:
          'Go behind the voting screen. Thumb-print next to your chosen candidate. Fold the ballot.',
    ),
    VotingInstruction(
      step: '06',
      title: 'Deposit Ballot',
      description:
          'Drop your folded ballot into the ballot box. Your vote is now cast and secret.',
    ),
  ];

  static const List<PollingLocation> locations = [
    PollingLocation(
      id: '001',
      name: 'Minna Central Primary School',
      address: '12 Paiko Road, Minna',
      lga: 'Chanchaga',
      state: 'Niger State',
      openTime: '8:00 AM',
      closeTime: '2:30 PM',
      isAccessible: true,
    ),
    PollingLocation(
      id: '002',
      name: 'FUTMinna Lecture Hall A',
      address: 'Gidan Kwano Campus, Minna',
      lga: 'Bosso',
      state: 'Niger State',
      openTime: '8:00 AM',
      closeTime: '2:30 PM',
      isAccessible: true,
    ),
    PollingLocation(
      id: '003',
      name: 'Tunga Community Hall',
      address: '3 Ahmadu Bello Way, Tunga',
      lga: 'Chanchaga',
      state: 'Niger State',
      openTime: '8:00 AM',
      closeTime: '2:30 PM',
      isAccessible: false,
    ),
    PollingLocation(
      id: '004',
      name: 'Kpakungu Town Hall',
      address: 'Kpakungu, Minna',
      lga: 'Bosso',
      state: 'Niger State',
      openTime: '8:00 AM',
      closeTime: '2:30 PM',
      isAccessible: true,
    ),
    PollingLocation(
      id: '005',
      name: 'Maikunkele Primary School',
      address: 'Maikunkele Village, Minna',
      lga: 'Bosso',
      state: 'Niger State',
      openTime: '8:00 AM',
      closeTime: '2:30 PM',
      isAccessible: false,
    ),
  ];
}