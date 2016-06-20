--Xyz Fusion
local id,ref=GIR()
function ref.start(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(ref.target)
	e1:SetOperation(ref.activate)
	c:RegisterEffect(e1)
end
function ref.filter1(c)
	return c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
end
function ref.filter0(c,e)
	return not c:IsImmuneToEffect(e) and c:IsCanBeFusionMaterial(true)
end
function ref.filter2(c,e,tp,m,chkf)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,nil,chkf)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Group.CreateGroup()
		local g=Duel.GetMatchingGroup(ref.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
		local tc=g:GetFirst()
		while tc do
			local og=tc:GetOverlayGroup()
			local oc=og:GetFirst()
			while oc do
				if ref.filter0(oc,e) then mg1:AddCard(oc) end
				oc=og:GetNext()
			end
			tc=g:GetNext()
		end
		--if not res then
		  --  local ce=Duel.GetChainMaterial(tp)
			--if ce~=nil then
			  --  local fgroup=ce:GetTarget()
				--local mg2=fgroup(ce,e,tp)
				--res=Duel.IsExistingMatchingCard(ref.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,chkf)
	   --	 end
	 --   end
		return Duel.IsExistingMatchingCard(ref.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,chkf)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Group.CreateGroup()
	local g=Duel.GetMatchingGroup(ref.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	local tc=g:GetFirst()
	while tc do
		local og=tc:GetOverlayGroup()
		local oc=og:GetFirst()
		while oc do
			if ref.filter0(oc,e) then mg1:AddCard(oc) end
			oc=og:GetNext()
		end
		tc=g:GetNext()
	end
	local sg1=Duel.GetMatchingGroup(ref.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,chkf)
--	local mg2=nil
  --  local sg2=nil
	--local ce=Duel.GetChainMaterial(tp)
   -- if ce~=nil then
	--	local fgroup=ce:GetTarget()
	 --   mg2=fgroup(ce,e,tp)
	  --  sg2=Duel.GetMatchingGroup(ref.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,chkf)
 --   end
	if sg1:GetCount()>0 then--or (sg2~=nil and sg2:GetCount()>0) then
		--local sg=sg1:Clone()
	   -- if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg1:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		--if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	   -- else
		--	local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
		   -- local fop=ce:GetOperation()
		  --  fop(ce,e,tp,tc,mat2)
		--end
		tc:CompleteProcedure()
	end
end
