# CAN BE INPUT FOR KALMAN FILTER 
## [srch_cx], [srch_cy] : the x/y coordinate of the center of the target.

## [srch_frame] : the image to be cropped.
### self.frame[seq_idx],[second_frame_idx]
### seq_idx: (int) The index of a sequence inside the whole dataset  
### seq_idx from function
    def __getitem__(self, idx):
        """ Returns the inputs and output for the learning problem. The input
        consists of an reference image tensor and a search image tensor, the
        output is the corresponding label tensor.

        Args:
            idx: (int) The index of a sequence inside the whole dataset, from
                which the function will choose the reference and search frames.

        Returns:
            ref_frame (torch.Tensor): The reference frame with the
                specified size.
            srch_frame (torch.Tensor): The search frame with the
                specified size.
            label (torch.Tensor): The label created with the specified
                function in self.label_fcn.
        """
        seq_idx = self.list_idx[idx]
### second_frame_idx: (int) The index of the search frame insidethe sequence.
### second_frame_idx from function
    def get_pair(self, seq_idx, frame_idx=None):
        """ Gets two frames separated by at most self.max_frame_sep frames (in
        both directions), both contained in the sequence corresponding to the
        given index.

        Args:
            seq_idx: (int) The index of the sequence from which sequence we
                randomly choose one or two frames.
            frame_idx: (int) Optional, the index of the first frame of the
                pair we are constructing

        Returns:
            first_frame_idx: The index of the reference frame inside self.frames
            second_frame_idx: The index of the search frame inside self.frames
        """
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
