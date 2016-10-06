--Spatial Procedure
function c450.initial_effect(c)
	if not c450.global_check then
		c450.global_check=true
		--register
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetOperation(c450.op)
		Duel.RegisterEffect(e1,0)
	end
end
function c450.regfilter(c)
	return c.spatial
end
function c450.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c450.regfilter,0,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(450)==0 then
			tc:EnableReviveLimit()
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			e1:SetRange(LOCATION_EXTRA)
			if tc.addt_spatial then
				e1:SetCountLimit(1,20001000)
				e1:SetCondition(c450.aspcon)
				e1:SetOperation(c450.aspop)
			elseif tc.subt_spatial then
				e1:SetCountLimit(1,20002000)
				e1:SetCondition(c450.sspcon)
				e1:SetOperation(c450.sspop)
			elseif tc.mult_spatial then
				e1:SetCountLimit(1,20003000)
				e1:SetCondition(c450.mspcon)
				e1:SetOperation(c450.mspop)
			elseif tc.divs_spatial then
				e1:SetCountLimit(1,20004000)
				e1:SetCondition(c450.dspcon)
				e1:SetOperation(c450.dspop)
			end
			e1:SetValue(0x7150)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetCode(EVENT_SPSUMMON_SUCCESS)
			e2:SetCondition(function(e) return bit.band(e:GetHandler():GetSummonType(),0x7150)==0x7150 end)
			e2:SetOperation(function(e) e:GetHandler():CompleteProcedure() end)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(tc)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e3:SetCode(EFFECT_REMOVE_TYPE)
			e3:SetValue(TYPE_XYZ)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(tc)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			e4:SetValue(1)
			tc:RegisterEffect(e4)
			local e5=Effect.CreateEffect(tc)
			e5:SetType(EFFECT_TYPE_FIELD)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE)
			e5:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e5:SetTargetRange(LOCATION_OVERLAY+LOCATION_ONFIELD,0)
			e5:SetTarget(function(e,c) return c==e:GetHandler() end)
			e5:SetValue(LOCATION_REMOVED)
			Duel.RegisterEffect(e5,0)
			local e6=Effect.CreateEffect(tc)
			e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e6:SetCode(EVENT_TO_GRAVE)
			e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e6:SetOperation(function(e) local c=e:GetHandler() Duel.SendtoHand(c,nil,REASON_RULE) if not c:IsLocation(LOCATION_EXTRA) then Duel.SendtoDeck(c,nil,0,REASON_RULE) end end)
			tc:RegisterEffect(e6)
			tc:RegisterFlagEffect(450,0,0,1)
		end
		tc=g:GetNext()
	end
end
function c450.addfilter(c,x,f1,f2)
	return c:GetLevel()<x and c:IsAbleToRemoveAsCost() and ((not f1 or f1(c)) or (not f2 or f2(c)))
end
function c450.addsfilter1(c,x,g,f1,f2)
	if f1 and not f1(c) then return false end
	local lv=c:GetLevel()
	local rk=c:GetRank()
	return g:IsExists(c450.addsfilter2,1,c,x,lv,rk,f2)
end
function c450.addsfilter2(c,x,lv,rk,f)
	return c:GetLevel()+lv==x or c:GetLevel()+rk==x and (not f or f(c))
end
function c450.aspcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return end
	local g=Duel.GetMatchingGroup(c450.addfilter,tp,LOCATION_MZONE,0,nil,c:GetOriginalRank(),c.material1,c.material2)
	return g:IsExists(c450.addsfilter1,1,nil,c:GetOriginalRank(),g,c.material1,c.material2) and c:GetFlagEffect(743000003)==0
end
function c450.srfilter(c,f1,f2)
	return f1(c) and not f2(c)
end
function c450.spatial(c)
	return c:GetFlagEffect(450)>0
end
function c450.aspop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Group.CreateGroup()
	local x=c:GetOriginalRank()
	local g=Duel.GetMatchingGroup(c450.addfilter,tp,LOCATION_MZONE,0,nil,x,c.material1,c.material2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc1=g:FilterSelect(tp,c450.addsfilter1,1,1,nil,x,g):GetFirst()
	mg:AddCard(tc1)
	if c.material1(tc1) and not c.material2(tc1) then g:Remove(c450.srfilter,nil,c.material1,c.material2) end
	if c.material2(tc1) and not c.material1(tc1) then g:Remove(c450.srfilter,nil,c.material2,c.material1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc2=g:FilterSelect(tp,c450.addsfilter2,1,1,tc1,x,tc1:GetLevel(),tc1:GetRank())
	mg:Merge(tc2)
	c:SetMaterial(mg)
	local fg=mg:Filter(Card.IsFacedown,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	Duel.Remove(mg,POS_FACEUP,REASON_MATERIAL+0x7150)
	local ec=Duel.GetMatchingGroup(c450.spatial,tp,LOCATION_MZONE,0,nil)
	if ec:GetCount()>0 then Duel.Remove(ec,POS_FACEUP,REASON_EFFECT) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetOperation(c450.splimit)
	e1:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetLabel(c:GetOriginalRank())
	e2:SetTarget(c450.reptg)
	e2:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e2)
	--cannot release
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetValue(function(e) return e:GetHandler():GetRank()>1 end)
	e5:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	c:RegisterEffect(e7)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_RANK)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(function(e) local djn=e:GetLabelObject():GetLabel() if djn~=0 then return djn end return 1 end)
	e3:SetLabelObject(e2)
	e3:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e3)
end
function c450.subfilter(c,x,f1,f2)
	return (c:GetLevel()~=x or c:GetRank()~=x) and c:IsAbleToRemoveAsCost() and ((not f1 or f1(c)) or (not f2 or f2(c)))
end
function c450.subsfilter1(c,x,g,f1,f2)
	local lv=c:GetLevel()
	local rk=c:GetRank()
	if f2 and f2(c) and not (f1 and f1(c)) then
		return g:IsExists(c450.subsfilter2,1,c,x,lv,rk,f1,nil)
	elseif f1 and f1(c) and not (f2 and f2(c)) then
		return g:IsExists(c450.subsfilter2,1,c,x,lv,rk,f2,nil)
	elseif f1 and f1(c) and f2 and f2(c) then
		return g:IsExists(c450.subsfilter2,1,c,x,lv,rk,f1,f2)
	end
	return false
end
function c450.subsfilter2(c,x,lv,rk,f1,f2)
	return (f1(c) or (f2 and f2(c)))
		and ((c:GetLevel()>0 and lv>0 and math.abs(c:GetLevel()-lv)==x)
		or (c:GetLevel()>0 and rk>0 and math.abs(c:GetLevel()-rk)==x)
		or (c:GetRank()>0 and lv>0 and math.abs(c:GetRank()-lv)==x)
		or (c:GetRank()>0 and rk>0 and math.abs(c:GetRank()-rk)==x))
end
function c450.sspcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return end
	local g=Duel.GetMatchingGroup(c450.subfilter,tp,LOCATION_MZONE,0,nil,c:GetOriginalRank(),c.material1,c.material2)
	return g:IsExists(c450.subsfilter1,1,nil,c:GetOriginalRank(),g,c.material1,c.material2) and c:GetFlagEffect(743000003)==0
end
function c450.sspop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Group.CreateGroup()
	local x=c:GetOriginalRank()
	local f1=c.material1
	local f2=c.material2
	local g=Duel.GetMatchingGroup(c450.subfilter,tp,LOCATION_MZONE,0,nil,x,f1,f2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc1=g:FilterSelect(tp,c450.subsfilter1,1,1,nil,x,g,f1,f2):GetFirst()
	mg:AddCard(tc1)
	if f1(tc1) and not f2(tc1) then g:Remove(c450.srfilter,nil,f1,f2) end
	if f2(tc1) and not f1(tc1) then g:Remove(c450.srfilter,nil,f2,f1) f1,f2=f2,f1 end
	local tc2=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if f1(tc1) and f2(tc1) then
		tc2=g:FilterSelect(tp,c450.subsfilter2,1,1,tc1,x,tc1:GetLevel(),tc1:GetRank(),f1,f2)
	else tc2=g:FilterSelect(tp,c450.subsfilter2,1,1,tc1,x,tc1:GetLevel(),tc1:GetRank(),f1,nil) end
	mg:Merge(tc2)
	c:SetMaterial(mg)
	local fg=mg:Filter(Card.IsFacedown,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	Duel.Remove(mg,POS_FACEUP,REASON_MATERIAL+0x7150)
	local ec=Duel.GetMatchingGroup(c450.spatial,tp,LOCATION_MZONE,0,nil)
	if ec:GetCount()>0 then Duel.Remove(ec,POS_FACEUP,REASON_EFFECT) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetOperation(c450.splimit)
	e1:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetLabel(c:GetOriginalRank())
	e2:SetTarget(c450.reptg)
	e2:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e2)
	--cannot release
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetValue(function(e) return e:GetHandler():GetRank()>1 end)
	e5:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	c:RegisterEffect(e7)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_RANK)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(function(e) local djn=e:GetLabelObject():GetLabel() if djn~=0 then return djn end return 1 end)
	e3:SetLabelObject(e2)
	e3:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e3)
end
function c450.mltfilter(c,f1,f2,tp)
	return c:IsAbleToRemoveAsCost() and ((f1 and f1(c)
		and Duel.IsExistingMatchingCard(c450.mltfilter2,tp,LOCATION_MZONE,0,1,c,f2,nil))
		or (f2 and f2(c) and Duel.IsExistingMatchingCard(c450.mltfilter2,tp,LOCATION_MZONE,0,1,c,f1,nil))
		or (f1 and f1(c) and f2 and f2(c) and Duel.IsExistingMatchingCard(c450.mltfilter2,tp,LOCATION_MZONE,0,1,c,f1,f2)))
end
function c450.mltfilter2(c,f1,f2)
	return c:IsAbleToRemoveAsCost() and (f1(c) or (f2 and f2(c)))
end
function c450.mspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and Duel.IsExistingMatchingCard(c450.mltfilter,tp,LOCATION_MZONE,0,1,nil,c.material1,c.material2,tp) and c:GetFlagEffect(743000003)==0
end
function c450.mspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c450.mltfilter,tp,LOCATION_MZONE,0,nil,c.material1,c.material2,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:Select(tp,1,1,nil)
	local tc1=tc:GetFirst()
	if c.material1(tc1) and not c.material2(tc1) then g:Remove(c450.srfilter,nil,c.material1,c.material2) end
	if c.material2(tc1) and not c.material1(tc1) then g:Remove(c450.srfilter,nil,c.material2,c.material1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc2=g:Select(tp,1,1,tc1)
	tc:Merge(tc2)
	c:SetMaterial(tc)
	local fg=tc:Filter(Card.IsFacedown,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	local atk=0
	local def=0
	local rg=tc:GetFirst()
	while rg do
		local atk1=rg:GetAttack()
		local def1=rg:GetDefense()
		atk=atk+atk1
		def=def+def1
		rg=tc:GetNext()
	end
	Duel.Remove(tc,POS_FACEUP,REASON_MATERIAL+0x7150)
	local ec=Duel.GetMatchingGroup(c450.spatial,tp,LOCATION_MZONE,0,nil)
	if ec:GetCount()>0 then Duel.Remove(ec,POS_FACEUP,REASON_EFFECT) end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SET_BASE_ATTACK)
	e0:SetReset(RESET_EVENT+0xff0000)
	e0:SetValue(atk)
	c:RegisterEffect(e0)
	local e4=e0:Clone()
	e4:SetCode(EFFECT_SET_BASE_DEFENSE)
	e4:SetValue(def)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetOperation(c450.splimit)
	e1:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetLabel(c:GetOriginalRank())
	e2:SetTarget(c450.reptg)
	e2:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e2)
	--cannot release
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetValue(function(e) return e:GetHandler():GetRank()>1 end)
	e5:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	c:RegisterEffect(e7)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_RANK)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(function(e) local djn=e:GetLabelObject():GetLabel() if djn~=0 then return djn end return 1 end)
	e3:SetLabelObject(e2)
	e3:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e3)
end
function c450.divspfilter(c,tg,f,stat,indc)
	if not c:IsAbleToRemoveAsCost() then return false end
	local st1=stat(c)
	if not indc then return false end
	local st2=indc(c)
	if st2<=0 then return false end
	local mhb=st1/st2
	while mhb>=10 or mhb<1 do
		while mhb>=10 do mhb=mhb/10 end
		while mhb<1 do mhb=mhb*10 end
	end
	local mhc=mhb-math.floor(mhb)
	if mhc>=0.5 then mhb=math.ceil(mhb) else mhb=math.floor(mhb) end
	return (not f or f(c)) and (mhb==tg or mhb==math.ceil(tg/2) or mhb==math.floor(tg/2))
end
function c450.dspcon(e,c)
	if c==nil then return true end
	if not c.divs_spatial then return false end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c450.divspfilter,tp,LOCATION_MZONE,0,1,nil,c:GetOriginalRank(),c.material1,c.stat,c.indicator1) and c:GetFlagEffect(743000003)==0
end
function c450.dspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c450.divspfilter,tp,LOCATION_MZONE,0,1,1,nil,c:GetOriginalRank(),c.material1,c.stat,c.indicator1)
	c:SetMaterial(g)
	local fg=g:Filter(Card.IsFacedown,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+0x7150)
	local ec=Duel.GetMatchingGroup(c450.spatial,tp,LOCATION_MZONE,0,nil)
	if ec:GetCount()>0 then Duel.Remove(ec,POS_FACEUP,REASON_EFFECT) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetOperation(c450.splimit)
	e1:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetLabel(c:GetOriginalRank())
	e2:SetTarget(c450.reptg)
	e2:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e2)
	--cannot release
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetValue(function(e) return e:GetHandler():GetRank()>1 end)
	e5:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	c:RegisterEffect(e7)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_RANK)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(function(e) local djn=e:GetLabelObject():GetLabel() if djn~=0 then return djn end return 1 end)
	e3:SetLabelObject(e2)
	e3:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e3)
end
function c450.splimit(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(743000003,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
end
function c450.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE end
	local ck=false
	if Duel.CheckEvent(EVENT_SPSUMMON) or c:GetRank()<=1 or c:IsLocation(LOCATION_OVERLAY) then
		ck=true
	end
	if ck then
		if Duel.Remove(c,POS_FACEUP,r)==0 then
			Duel.BreakEffect()
			Duel.SendtoHand(c,nil,r)
			if not c:IsLocation(LOCATION_EXTRA) then
				Duel.SendtoDeck(c,nil,0,r)
			end
		end
		return true
	end
	local dje=e:GetLabel()
	e:SetLabel(dje-1)
	return true
end
