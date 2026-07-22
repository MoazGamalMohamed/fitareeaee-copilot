import 'package:fitareeaee/core/user_path.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('rider and sender roles resolve to the request path', () {
    expect(
      marketplacePathForRoles(const ['rider', 'sender']),
      MarketplacePath.rider,
    );
    expect(rolesForMarketplacePath(MarketplacePath.rider), const [
      'rider',
      'sender',
    ]);
  });

  test('driver and courier roles resolve to the offer path', () {
    expect(
      marketplacePathForRoles(const ['driver', 'courier']),
      MarketplacePath.driver,
    );
    expect(rolesForMarketplacePath(MarketplacePath.driver), const [
      'driver',
      'courier',
    ]);
  });

  test('legacy mixed roles keep their first declared marketplace path', () {
    expect(
      marketplacePathForRoles(const ['rider', 'driver']),
      MarketplacePath.rider,
    );
    expect(
      marketplacePathForRoles(const ['driver', 'rider']),
      MarketplacePath.driver,
    );
    expect(marketplacePathForRoles(const []), MarketplacePath.rider);
  });

  test(
    'account guidance keeps request and offer available as separate actions',
    () {
      expect(
        MarketplacePath.rider.accountGuidance,
        contains('publish an offer'),
      );
      expect(
        MarketplacePath.driver.accountGuidance,
        contains('create a request'),
      );
    },
  );
}
