class QueryKeys {
  QueryKeys._();

  static const profile = ['profile'];
  static const authStatus = ['authStatus'];
  static const adminEvents = ['adminEvents'];
  static List<String> adminDashboardAnalytics({
    String? fromDate,
    String? toDate,
  }) =>
      [
        'adminDashboardAnalytics',
        if (fromDate != null) fromDate,
        if (toDate != null) toDate,
      ];
  static const publicUpcomingEvents = ['publicEvents', 'upcoming'];
  static const homeUpcomingEvents = ['home', 'upcomingEvents'];
  static const publicClosedEvents = ['publicEvents', 'closed'];
  static List<String> adminEvent(String id) => ['adminEvent', id];
  static const myRegistrations = ['myRegistrations'];
  static const myUpcomingRegistrations = ['myRegistrations', 'upcoming'];
  static List<String> registrationDetail(String id) => [
    'registrationDetail',
    id,
  ];
  static List<String> eventRegistrationStatus(String eventId) => [
    'eventRegistrationStatus',
    eventId,
  ];
  static List<String> eventParticipants(String eventId) => [
    'eventParticipants',
    eventId,
  ];
  static List<String> eventAnalytics(String eventId) => [
    'eventAnalytics',
    eventId,
  ];

  static const login = ['mutation', 'login'];
  static const verifyLoginOtp = ['mutation', 'verifyLoginOtp'];
  static const register = ['mutation', 'register'];
  static const googleSignIn = ['mutation', 'googleSignIn'];
  static const forgotPassword = ['mutation', 'forgotPassword'];
  static const resetPassword = ['mutation', 'resetPassword'];
  static const updateProfile = ['mutation', 'updateProfile'];
  static const changePassword = ['mutation', 'changePassword'];
  static const updateTwoFactor = ['mutation', 'updateTwoFactor'];
  static const sendVerificationEmail = ['mutation', 'sendVerificationEmail'];
  static const verifyEmail = ['mutation', 'verifyEmail'];
  static const avatarUpload = ['mutation', 'avatarUpload'];
  static const createEvent = ['mutation', 'createEvent'];
  static const updateEvent = ['mutation', 'updateEvent'];
  static const updateEventCustomQuestions = [
    'mutation',
    'updateEventCustomQuestions',
  ];
  static const publishEvent = ['mutation', 'publishEvent'];
  static const closeEvent = ['mutation', 'closeEvent'];
  static const archiveEvent = ['mutation', 'archiveEvent'];
  static const pauseEventRegistrations = [
    'mutation',
    'pauseEventRegistrations',
  ];
  static const resumeEventRegistrations = [
    'mutation',
    'resumeEventRegistrations',
  ];
  static const deleteEvent = ['mutation', 'deleteEvent'];
}
