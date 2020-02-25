# CAN BE INPUT FOR KALMAN FILTER 
## [srch_cx], [srch_cy] : the x/y coordinate of the center of the target.

## [srch_frame] : the image to be cropped.
### self.frame[seq_idx],[second_idx]
### seq_idx: (int) The index of a sequence inside the whole dataset  
### second_idx: (int) The index of the search frame insidethe sequence.  

## [srch_ctx_size] : the side of the square region around the target, in pixels. 
### srch_ctx_size = ref_ctx_size * self.search_size / self.reference_size
### srch_ctx_size = (srch_ctx_size//2)*2 + 1
### reference_size = 127, search_size = 255
### ref_ctx_size from function
    def ref_context_size(self, h, w):
        """ This function defines the size of the reference region around the
        target as a function of its bounding box dimensions when the context
        margin is added.

        Args:
            h: (int) The height of the bounding box in pixels.
            w: (int) The width of the bounding box in pixels.
        Returns:
            ref_size: (int) The side of the square reference region in pixels.
                Note that it is always an odd integer.
        """
