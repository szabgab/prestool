function Presentation() {
    var presentation = this;

    presentation.slides = $('.slide');

    presentation.currentSlide = 0;
    presentation.totalSlides = presentation.slides.length;

    presentation.onnextslide = function() {};
    presentation.onprevslide = function() {};

    var loc = $(document).attr('location').hash;
    var match = /#slide(\d+)/i.exec(loc);
    if (match && match[1] && match[1] < presentation.slides.size()) {
        presentation.currentSlide = match[1];
    }

	presentation.reset = function() {
		for (i=0; i < presentation.totalSlides; i++) {
        	var slide = presentation.slides[i];
        	if (slide) {
        		$(slide).removeClass('far-past past current future far-future');
			}
		}
	}

    presentation.setClass = function (n, newClass) {
        var slide = presentation.slides[n];

        if (!slide) { return; }

        //$(slide).removeClass('far-past past current future far-future');
        $(slide).addClass(newClass);
    };

    presentation.animateSlide = function (n, params) {
        var slide = presentation.slides[n];

        if (!slide) { return; }

        $(slide).animate(params);
    };

    presentation.animateSlides = function(direction) {
        if (direction == 'left') {
            presentation.animateSlide(presentation.currentSlide - 2, '.far-past');
            presentation.animateSlide(presentation.currentSlide - 1, '.past');
            presentation.animateSlide(presentation.currentSlide, '.current');
            presentation.animateSlide(presentation.currentSlide + 1, '.future');
            presentation.animateSlide(presentation.currentSlide + 2, '.far-future');
        }
        else {
            presentation.animateSlide(presentation.currentSlide + 2, '.far-future');
            presentation.animateSlide(presentation.currentSlide + 1, '.future');
            presentation.animateSlide(presentation.currentSlide, '.current');
            presentation.animateSlide(presentation.currentSlide - 1, '.past');
            presentation.animateSlide(presentation.currentSlide - 2, '.far-past');
        }

		presentation.setUrl();
    };
	presentation.setUrl = function() {
        if (presentation.currentSlide > 0) {
            $(document).attr('location').hash = '#slide' + presentation.currentSlide;
        }
        else {
            $(document).attr('location').hash = '';
        }
	}

    presentation.initSlides = function () {
        presentation.setClass(presentation.currentSlide - 2, 'far-past');
        presentation.setClass(presentation.currentSlide - 1, 'past');
        presentation.setClass(presentation.currentSlide, 'current');
        presentation.setClass(presentation.currentSlide + 1, 'future');
        presentation.setClass(presentation.currentSlide + 2, 'far-future');
    };

    presentation.nextSlide = function () {
        if (presentation.currentSlide >= presentation.slides.size() - 1) {
            return;
        }

        presentation.currentSlide++;
        presentation.animateSlides('right');

        presentation.onnextslide();
    };

    presentation.prevSlide = function () {
        if (presentation.currentSlide <= 0) {
            return;
        }

        presentation.currentSlide--;
        presentation.animateSlides('left');

        presentation.onprevslide();
    };

    presentation.firstSlide = function () {
        if (presentation.currentSlide <= 0) {
            return;
        }

		presentation.reset();
        presentation.currentSlide = 0;
       	presentation.animateSlides('left');

//		while (presentation.currentSlide > 0 ) {
//            presentation.currentSlide--;
//        	presentation.animateSlides('left');
//		}

//        presentation.initSlides();
		presentation.setUrl();

        presentation.onprevslide();
    };


    presentation.KeyDown =  function(code) {
          // Right Arrow or Space
          if (code == '39' || code == '32') {
            presentation.nextSlide();
          }

          // Left Arrow
          else if (code == '37') {
            presentation.prevSlide();

          } else if (code == '36') { // Home
            presentation.firstSlide();
          } else {
            //alert(code);
          }
	};

    presentation.initSlides();
};
