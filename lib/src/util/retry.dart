import 'dart:async';

Future<T> retryAsync<T>(Future<T> func(), int retries, Duration delay,
    {bool test(error)?}) {
  return func().catchError((error) {
    if (retries == 0) {
      // ignore: invalid_return_type_for_catch_error
      return Future.error(error);
    } else {
      if (test is Function && !test!(error)) {
        // ignore: invalid_return_type_for_catch_error
        return new Future.error(error);
      }
      return new Future.delayed(
          delay, () => retryAsync(func, retries - 1, delay));
    }
  });
}
