enum FilterType {
  interval,
  range,
  minChange,
}

abstract class Filter {
  FilterType type;

  Filter(this.type);

  Map<String, dynamic> toJson() {
    return {
      "type": type.name,
    };
  }
}

class IntervalFilter extends Filter {
  int interval;

  IntervalFilter(this.interval) : super(FilterType.interval);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "parameter": interval,
    };
  }
}

class RangeFilter extends Filter {
  int below;
  int above;

  RangeFilter(this.below, this.above) : super(FilterType.range);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "parameter": {
        "below": below,
        "above": above,
      },
    };
  }
}

class MinChangeFilter extends Filter {
  int minChange;

  MinChangeFilter(this.minChange) : super(FilterType.minChange);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "parameter": minChange,
    };
  }
}
