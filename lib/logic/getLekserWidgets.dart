Future<List<Widget>> getLekserWidgets(context, subjects, date) async {
  List<Widget> children = [];
  List brukteFarger = [];
  await makeCompleteDayClass(context, subjects: subjects, dateToShow: date)
      .then((value) {
    for (CompleteDayClass completeDayClass in value) {
      for (Lekse lekse in completeDayClass.lekser) {
        children.add(Padding(
          padding: const EdgeInsets.only(left: 7.5, right: 7.5, bottom: 25),
          child: GestureDetector(
            onTap: () => showLekse(
              context,
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: ListTile(
                      title: Text(lekse.tittel),
                      subtitle: Text(lekse.beskrivelse),
                    ),
                  ),
                ],
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 2.2,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Icon(
                    (() {
                      if (iconIndex[lekse.tittel] != null) {
                        return iconIndex[lekse.tittel];
                      } else
                        return iconIndex["default"];
                    }()),
                    color: Colors.white,
                    size: 90,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    lekse.fag,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    "${DateFormat(DateFormat.WEEKDAY).format(lekse.date).capitalize()} uke ${lekse.date.weekOfYear}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: (() {
                  Random rnd = new Random();
                  int min = 0, max = lekserColors.length;
                  int r = min + rnd.nextInt(max - min);
                  int maxColorsLen = brukteFarger.length;

                  if (maxColorsLen <= max) {
                    while (brukteFarger.contains(r)) {
                      r = min + rnd.nextInt(max - min);
                    }
                    print("brukte: $brukteFarger");
                    brukteFarger.add(r);
                  }

                  return lekserColors[r];
                }()),
                borderRadius: BorderRadius.circular(
                  35,
                ),
              ),
            ),
          ),
        ));
      }
    }
  });
  return children;
}
