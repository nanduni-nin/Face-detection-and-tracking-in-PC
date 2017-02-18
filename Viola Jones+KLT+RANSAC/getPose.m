function [ roll, pitch, yaw] = getPose( xyPoints )
    if size(xyPoints, 1) == 5 && size(xyPoints, 2) == 2
        reye = xyPoints(1, :);
        leye = xyPoints(2, :);
        
        tanroll = (reye(1,2) - leye(1,2)) / (reye(1,1) - leye(1,1));
        roll = atand(tanroll);
        
        eyemiddle = [leye(1,1) + ((reye(1,1)-leye(1,1))/2), (max([reye(1,2) leye(1,2)]) - min([reye(1,2) leye(1,2)]))/2 + min([reye(1,2) leye(1,2)])];
        
        if ~isinf(1/tanroll) && ~isnan(1/tanroll) && size(reye, 2) == 2 && size(leye, 2) == 2
        
%             syms x y;
%     %         facenormaleq = y == (-1/tanroll)x + c;
%             c1 = eyemiddle(1, 2) + ((1/tanroll) * eyemiddle(1, 1));
%             facenormaleq = y + (1/tanroll)*x == c1;
% 
            mouth = xyPoints(4, :);
% 
%     %         mouthlineeq = y == tanroll x + c2
%             c2 =  mouth(1,2) - (tanroll * mouth(1,1));
%             mouthlineeq = y - (tanroll * x) == c2;
            
%             [A,B] = solve(facenormaleq, mouthlineeq);
%             mouthmiddle = [A B];
            mouthmiddle = mouth;
            
%             comp = double([abs(mouth(1,1)-mouthmiddle(1,1)) abs(mouth(1,2)-mouthmiddle(1,2))]);
%             disp(comp);
            if size(mouthmiddle, 1) == 1 && size(mouthmiddle, 2) == 2
                nosebase = [(4 * eyemiddle(1,1) + 6*mouthmiddle(1,1))/10,(4 * eyemiddle(1,2) + 6*mouthmiddle(1,2))/10];

                Rn = 0.3;
                lengthface = sqrt(((eyemiddle(1,1)-mouthmiddle(1,1))^2) + ((eyemiddle(1,2)-mouthmiddle(1,2))^2));

                lengthnose = Rn * lengthface;
                nose = xyPoints(3, :);
                
                nose3dheight = sqrt(lengthnose^2 - (nose(1, 1)-nosebase(1,1))^2 - (nose(1, 2)-nosebase(1,2))^2);

                cosyaw = (nose(1,1) - nosebase(1,1))/sqrt((nose(1,1) - nosebase(1,1))^2 + nose3dheight^2);
                yaw = 90 - acosd(double(cosyaw));
                
                cospitch =  (nosebase(1,2) - nose(1,2))/ sqrt(nose3dheight^2 + (nose(1,2) - nosebase(1,2))^2);
%                 cospitch = (nosebase(1,2) - nose(1,2)) / lengthnose;
                pitch = 90- acosd(double(cospitch));
            else
                pitch = 0;
                yaw = 0;
            end            
        else
            pitch = 0;
            yaw = 0;
        end
        
    else
        roll = 'Nan';
        pitch = 'Nan';
        yaw = 'Nan';
    end
    
%     roll = 'Nan';
%     pitch = 'Nan';
%     yaw = 'Nan';
end
