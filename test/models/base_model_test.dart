import 'package:uksc_dashboard/models/base_model.dart';
import 'package:uksc_dashboard/api/viss/models/response.dart';
import 'package:test/test.dart';

void main() {
  group('Test updateFromJson', () {
    final baseModel = BaseModel(
        {'foo': 'test_value_initial_1', 'bar': 'test_value_initial_2'});

    test('basics', () {
      final timestampBeforeUpdate = baseModel.lastUpdated;
      // expect update performed
      expect(
          baseModel
              .updateFromJson({'foo': 'test_value_1', 'bar': 'test_value_2'}),
          true);
      // expect value updated
      expect(baseModel.data['foo'], 'test_value_1');
      expect(baseModel.data['bar'], 'test_value_2');
      // expect the timestamp of the last update has changed
      expect(baseModel.lastUpdated.isAfter(timestampBeforeUpdate), true);
    });

    test('key not present', () {
      final timestampBeforeUpdate = baseModel.lastUpdated;
      // expect update performed
      expect(baseModel.updateFromJson({'foo': 'test_value'}), true);
      // expect value updated
      expect(baseModel.data['foo'], 'test_value');
      // expect the timestamp of the last update has changed
      expect(baseModel.lastUpdated.isAfter(timestampBeforeUpdate), true);
    });
  });

  group('Test updateFromData', () {
    test('parse doubles', () {
      // Test that data is automatically parsed to the correct type based on the type of the initial value.
      final newDatumTimestamp = DateTime.now();
      final goodData = [
        Data('test_double', [DataPoint(newDatumTimestamp, "3.0")]),
        Data('test_double', [DataPoint(newDatumTimestamp, 3.0)]),
        Data('test_double', [DataPoint(newDatumTimestamp, "3")]),
        Data('test_double', [DataPoint(newDatumTimestamp, 3)]),
        Data('test_double', [DataPoint(newDatumTimestamp, "0.003e3")])
      ];
      final badData = [
        Data('test_double', [DataPoint(newDatumTimestamp, "i am invalid")]),
        // NOTE: NaN would be allowable. See: https://api.flutter.dev/flutter/dart-core/double/tryParse.html
        Data('test_double', [DataPoint(newDatumTimestamp, "nan")]),
        Data('test_double', [DataPoint(newDatumTimestamp, "-inf")]),
        Data('test_double', [DataPoint(newDatumTimestamp, "inf")]),
      ];

      for (final goodDatum in goodData) {
        final baseModel = BaseModel({'test_double': 1.0});
        var listenerCalled = false;
        baseModel.addListener(() {
          listenerCalled = true;
        });

        expect(baseModel.updateFromData([goodDatum]), true,
            reason:
                'Unable to parse datum into a double! Failed datum value: "${goodDatum.latest}", type: "${goodDatum.latest.runtimeType}"');
        expect(baseModel.data['test_double'], 3.0);
        expect(listenerCalled, true,
            reason:
                "notifyListeners() was not called on value change. This breaks the entire codebase!");
      }

      for (final badDatum in badData) {
        final baseModel = BaseModel({'test_double': 1.0});
        var listenerCalled = false;
        baseModel.addListener(() {
          listenerCalled = true;
        });

        expect(baseModel.updateFromData([badDatum]), false,
            reason:
                "Shouldn't have been able to parse datum into a double! Failed datum value: '${badDatum.latest}', type: '${badDatum.latest.runtimeType}'");
        expect(baseModel.data['test_double'], 1.0);
        expect(listenerCalled, false,
            reason:
                "notifyListeners() should not be called without a value change. This will be super slow!");
      }
    });

    test('parse ints', () {
      // Test that data is automatically parsed to the correct type based on the type of the initial value.
      final newDatumTimestamp = DateTime.now();
      final goodData = [
        Data('test_int', [DataPoint(newDatumTimestamp, "3")]),
        Data('test_int', [DataPoint(newDatumTimestamp, 3)]),
      ];
      final badData = [
        Data('test_int', [DataPoint(newDatumTimestamp, "i am invalid")]),
        Data('test_int', [DataPoint(newDatumTimestamp, "3.0")]),
        Data('test_int', [DataPoint(newDatumTimestamp, 3.0)]),
        Data('test_int', [DataPoint(newDatumTimestamp, "0.003e3")]),
        Data('test_int', [DataPoint(newDatumTimestamp, "3e0")])
      ];

      for (final goodDatum in goodData) {
        final baseModel = BaseModel({'test_int': 1});
        var listenerCalled = false;
        baseModel.addListener(() {
          listenerCalled = true;
        });

        expect(baseModel.updateFromData([goodDatum]), true,
            reason:
                'Unable to parse datum into an int! Failed datum value: "${goodDatum.latest}", type: "${goodDatum.latest.runtimeType}"');
        expect(baseModel.data['test_int'], 3);
        expect(listenerCalled, true,
            reason:
                "notifyListeners() was not called on value change. This breaks the entire codebase!");
      }

      for (final badDatum in badData) {
        final baseModel = BaseModel({'test_int': 1});
        var listenerCalled = false;
        baseModel.addListener(() {
          listenerCalled = true;
        });

        expect(baseModel.updateFromData([badDatum]), false,
            reason:
                "Shouldn't have been able to parse datum into an int! Failed datum value: '${badDatum.latest}', type: '${badDatum.latest.runtimeType}'");
        expect(baseModel.data['test_int'], 1);
        expect(listenerCalled, false,
            reason:
                "notifyListeners() should not be called without a value change. This will be super slow!");
      }
    });

    test('parse bools', () {
      // Test that data is automatically parsed to the correct type based on the type of the initial value.
      final newDatumTimestamp = DateTime.now();
      final goodData = [
        Data('test_bool', [DataPoint(newDatumTimestamp, "false")]),
        Data('test_bool', [DataPoint(newDatumTimestamp, "False")]),
        Data('test_bool', [DataPoint(newDatumTimestamp, "FALSE")]),
        Data('test_bool', [DataPoint(newDatumTimestamp, false)]),
      ];
      final badData = [
        Data('test_bool', [DataPoint(newDatumTimestamp, "i am invalid")]),
        Data('test_bool', [DataPoint(newDatumTimestamp, "0")]),
        Data('test_bool', [DataPoint(newDatumTimestamp, "NO")]),
      ];

      for (final goodDatum in goodData) {
        final baseModel = BaseModel({'test_bool': true});
        var listenerCalled = false;
        baseModel.addListener(() {
          listenerCalled = true;
        });

        expect(baseModel.updateFromData([goodDatum]), true,
            reason:
                'Unable to parse datum into a bool! Failed datum value: "${goodDatum.latest}", type: "${goodDatum.latest.runtimeType}"');
        expect(baseModel.data['test_bool'], false);
        expect(listenerCalled, true,
            reason:
                "notifyListeners() was not called on value change. This breaks the entire codebase!");
      }

      for (final badDatum in badData) {
        final baseModel = BaseModel({'test_bool': true});
        var listenerCalled = false;
        baseModel.addListener(() {
          listenerCalled = true;
        });

        expect(baseModel.updateFromData([badDatum]), false,
            reason:
                "Shouldn't have been able to parse datum into a bool! Failed datum value: '${badDatum.latest}', type: '${badDatum.latest.runtimeType}'");
        expect(baseModel.data['test_bool'], true);
        expect(listenerCalled, false,
            reason:
                "notifyListeners() should not be called without a value change. This will be super slow!");
      }
    });

    test('parse strings', () {
      // .... as if this needs a test... (you should always test)
      final newDatumTimestamp = DateTime.now();
      final goodData = [
        Data('test_string', [DataPoint(newDatumTimestamp, ":)")]),
      ];
      final badData = [
        Data('test_string', [DataPoint(newDatumTimestamp, true)]),
        Data('test_string', [DataPoint(newDatumTimestamp, 0)]),
        Data('test_string', [DataPoint(newDatumTimestamp, 0.0)]),
      ];

      for (final goodDatum in goodData) {
        final baseModel = BaseModel({
          'test_string':
              "hello future person please don't massacre this codebase :)"
        });
        var listenerCalled = false;
        baseModel.addListener(() {
          listenerCalled = true;
        });

        expect(baseModel.updateFromData([goodDatum]), true,
            reason:
                'Unable to parse datum into a string! Failed datum value: "${goodDatum.latest}", type: "${goodDatum.latest.runtimeType}"');
        expect(baseModel.data['test_string'], ":)");
        expect(listenerCalled, true,
            reason:
                "notifyListeners() was not called on value change. This breaks the entire codebase!");
      }

      for (final badDatum in badData) {
        final baseModel = BaseModel({'test_string': ":("});
        var listenerCalled = false;
        baseModel.addListener(() {
          listenerCalled = true;
        });

        expect(baseModel.updateFromData([badDatum]), false,
            reason:
                "Shouldn't have been able to parse datum into a string! Failed datum value: '${badDatum.latest}', type: '${badDatum.latest.runtimeType}'");
        expect(baseModel.data['test_string'], ":(");
        expect(listenerCalled, false,
            reason:
                "notifyListeners() should not be called without a value change. This will be super slow!");
      }
    });
  });
}
