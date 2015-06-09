$("document").ready(function(){
  var w = $( window ).width();
  var h = $( window ).height();

  var dataset, svg, xScale, yScale, summary;
  var width = (w -(w/10));
  var height = 600;
  var yDomainMin = (w > 700) ? 60000 : 80000;
  var fontColor = "#29b3ce";
  var circleColor = "orange";
  var leftPadding = 100;
  var i = -1;
  var j = -1;
  var fill = ["#FAD63C", "#3F7CAB", "#D00000", "#FF702D", "#AEB5C7", "#2D6CB7", "#7FBD42", "#B759A6", "#6082BB", "#F968EE"];
  var stroke = ["#333", "#FBD951", "#8F0C1C", "#33A9DB", "#4D8FFD", "#E71A24", "#000", "#333", "#000", "#F968EE"];

  $.ajax({
    type: "GET",
    contentType: "application/json; charset=utf-8",
    url: "/jobs",
    dataType: "json",
    success: function (data) {
      dataset = data;
      createSvg();
      setScales();
      createCircles();
      setLabels();
      setAxes();
    },
    error: function (result) {
      console.log("error");
      console.log(result);
    }
  });

  var createSvg = function() {
    svg = d3.select(".chart-container")
            .append("svg")
            .attr("width", width)
            .attr("height", height)
            .attr("viewBox", "0 0 "+(width+200)+" "+(height+120))
            .attr("preserveAspectRatio", "xMidYMid meet")
            .attr("id", "svg-canvas");
  };

  var setScales = function() {
    xScale = d3.scale
               .linear()
               .domain([0, 520])
               .range([0, width]);
    yScale = d3.scale
               .linear()
               .domain([yDomainMin, 130000])
               .range([height, 0]);
  };

  var createCircles = function() {
    svg.selectAll("circle")
       .data(d3.entries(dataset))
       .enter()
       .append("circle")
       .attr("cx", function(d) {
          return xScale(d.value.count);
        })
       .attr("cy", function(d) {
          return yScale(
            (d.value.total_salary_min + d.value.total_salary_max) / (d.value.count * 2)
          );
        })
       .attr("r", function(d) {
          return d.value.count/10;
        })
       .attr("fill", function() {
          i++;
          return fill[i];
        })
       .attr("stroke-width", 3)
       .attr("stroke", function() {
         j++;
         return stroke[j];
       })
       .attr("opacity", 0.75)
       .attr("class", "circle");
  };

  var setLabels = function() {
    svg.selectAll("text")
      .data(d3.entries(dataset))
      .enter()
      .append("text")
      .text(function(d) {
        avg_salary = (d.value.total_salary_min + d.value.total_salary_max) / (d.value.count * 2);
        return d.key + " ($" + avg_salary.toFixed(0).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ")";
      })
      .attr("x", function(d) {
        console.log(d.key);
        return xScale(d.value.count);
      })
      .attr("y", function(d) {
        return yScale(
          (d.value.total_salary_min + d.value.total_salary_max) / (d.value.count * 2)
        );
      })
      .attr("font-size", "11px")
      .attr("fill", "#000")
      .attr("class", "label");
  };

  var setAxes = function() {
    var commasFormatter = d3.format(",.0f");

    var xAxis = d3.svg.axis()
                  .scale(xScale)
                  .orient("bottom")
                  .ticks(9);
    
    svg.append("g")
       .attr("class", "axis")
       .attr("transform", "translate("+leftPadding+","+(height+40)+")")
       .call(xAxis);
    
    var yAxis = d3.svg.axis()
                  .scale(yScale)
                  .tickFormat(function(d) { return "$" + commasFormatter(d); })
                  .orient("left")
                  .ticks(6);

    svg.append("g")
       .attr("class", "axis")
       .attr("transform", "translate("+leftPadding+","+40+")")
       .call(yAxis);

    // Axis labels
    svg.append("text")
        .attr("transform", "translate("+(100+width/2)+","+(height+100)+")")
        .style("text-anchor", "middle")
        .text("Number of Jobs on AngelList with Skill Tag");
    
    svg.append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 10)
        .attr("x", (height/-2))
        .attr("dy", "1em")
        .style("text-anchor", "middle")
        .text("Average Salary");

  };

});
