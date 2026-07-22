enum MarketplacePath { rider, driver }

MarketplacePath marketplacePathForRoles(Iterable<String> roles) {
  for (final rawRole in roles) {
    switch (rawRole.trim().toLowerCase()) {
      case 'driver':
      case 'courier':
        return MarketplacePath.driver;
      case 'rider':
      case 'sender':
        return MarketplacePath.rider;
    }
  }
  return MarketplacePath.rider;
}

List<String> rolesForMarketplacePath(MarketplacePath path) => switch (path) {
  MarketplacePath.rider => const ['rider', 'sender'],
  MarketplacePath.driver => const ['driver', 'courier'],
};

extension MarketplacePathPresentation on MarketplacePath {
  bool get isDriver => this == MarketplacePath.driver;

  String get routeRole => isDriver ? 'driver' : 'rider';

  String get title => isDriver ? 'Driver / Courier' : 'Rider / Sender';

  String get creationLabel => isDriver ? 'Offer' : 'Request';

  String get creationTitle =>
      isDriver ? 'Offer a ride or delivery' : 'Request a ride or delivery';

  String get accountGuidance => isDriver
      ? 'Offer by default, or create a request whenever you need a ride or delivery.'
      : 'Request by default, or complete driver verification to publish an offer.';
}
