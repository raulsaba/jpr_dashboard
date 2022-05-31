import 'package:flutter_jpr_dashboard/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group('Network Info', () {
    group("isConnected", () {
      test(
        "should forward the call to DataConnectionChecker.hasConnection",
        () async {
          final tHasConnectionFuture = Future.value(true);

          when(mockInternetConnectionChecker.hasConnection)
              .thenAnswer((realInvocation) => tHasConnectionFuture);

          final result = networkInfoImpl.isConnected;

          verify(mockInternetConnectionChecker.hasConnection);
          expect(result, tHasConnectionFuture);
        },
      );
    });
  });
}
