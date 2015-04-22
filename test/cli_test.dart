// Copyright 2014 Google. All rights reserved. Use of this source code is
// governed by a BSD-style license that can be found in the LICENSE file.

library grinder.cli_test;

import 'package:grinder/grinder.dart';
import 'package:grinder/src/cli.dart';
import 'package:grinder/src/singleton.dart';
import 'package:unittest/unittest.dart';

bool isSetup = false;
Map ranTasks = {};

main() {
  group('cli', () {
    setUp(() {
      if (!isSetup) {
        isSetup = true;
        addTask(new GrinderTask('foo', taskFunction: _fooTask));
        addTask(new GrinderTask('bar', taskFunction: _barTask, depends: ['foo']));
      }

      _clear();
    });

    test('all ran', () {
      return handleArgs(['bar']).then((_) {
        expect(ranTasks['foo'], true);
        expect(ranTasks['bar'], true);
      });
    });

    test('printUsageAndDeps', () {
      printUsageAndDeps(createArgsParser(), grinder);
    });
  });
}

void _clear() => ranTasks.clear();

_fooTask() {
  ranTasks['foo'] = true;
  log('ran _fooTask');
}

_barTask(GrinderContext context) {
  ranTasks['bar'] = true;
  log('ran _barTask\n${context}');
}
