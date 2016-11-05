--サイバー・アポロ・ドラゴン／バスター
function c101010139.initial_effect(c)
c:EnableReviveLimit()
	--pendulum summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC_G)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,10000000)
	e3:SetCondition(c101010139.pscon)
	e3:SetOperation(c101010139.psop)
	e3:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e3)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c101010139.activate)
	c:RegisterEffect(e1)
	--Cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c101010139.splimit)
	c:RegisterEffect(e1)
	--atk (spell)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c101010139.atktg)
	e3:SetValue(800)
	c:RegisterEffect(e3)
	--move to Pendulum Scale (monster)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetDescription(aux.Stringid(101010139,0))
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c101010139.pencost)
	e5:SetTarget(c101010139.pentg)
	e5:SetOperation(c101010139.penop)
	c:RegisterEffect(e5)
	--Special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(101010139,1))
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c101010139.spcon)
	e6:SetTarget(c101010139.sptg)
	e6:SetOperation(c101010139.spop)
	c:RegisterEffect(e6)
	--assault mode activate
	if not c101010139.global_check then
		c101010139.global_check=true
		local ama=Effect.CreateEffect(c)
		ama:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ama:SetCode(EVENT_ADJUST)
		ama:SetOperation(c101010139.amaop)
		Duel.RegisterEffect(ama,0)
	end
end
function c101010139.amafilter(c)
	return c:GetOriginalCode()==80280737
end
function c101010139.amaop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(c101010139.amafilter,c:GetControler(),0xff,0xff,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(101010139)==0 then
			--Activate
			local e1=Effect.CreateEffect(tc)
			e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e1:SetDescription(aux.Stringid(101010139,2))
			e1:SetType(EFFECT_TYPE_ACTIVATE)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
			e1:SetCost(c101010139.cost)
			e1:SetTarget(c101010139.tg)
			e1:SetOperation(c101010139.op)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(101010139,0,0,1)  
		end
		tc=g:GetNext()
	end
end
function c101010139.filter1(c,e,tp)
	return c:IsCode(101010139) and c:IsType(TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(c101010139.filter2,tp,LOCATION_DECK,0,1,nil,e,tp)
end
function c101010139.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101010139.filter1,1,nil,e,tp) end
	local rg=Duel.SelectReleaseGroup(tp,c101010139.filter1,1,1,nil,e,tp)
	Duel.Release(rg,REASON_COST)
end
function c101010139.filter2(c,e,tp)
	return c:IsCode(101010139) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c101010139.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101010139.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstMatchingCard(c101010139.filter2,tp,LOCATION_DECK,0,nil,e,tp)
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP_ATTACK) then
		tc:CompleteProcedure()
	end
end
function c101010139.splimit(e,se,sp,st)
	if bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM then return false end
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c101010139.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
function c101010139.atktg(e,c)
	return c:IsRace(RACE_MACHINE)
end
function c101010139.cpfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE)
end
function c101010139.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010139.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101010139.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101010139.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc1=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,7)
	if chk==0 then return not tc1 or not tc2 end
end
function c101010139.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,7)
	if tc1 and tc2 then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function c101010139.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c101010139.spfilter(c,e,tp)
	return c:IsCode(101010139) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010139.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101010139.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101010139.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101010139.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101010139.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101010139.psfilter(c,e,tp,lscale,rscale)
	local lv=0

	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
		and not c:IsForbidden()
end
function c101010139.pscon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	if c:GetSequence()~=6 then return false end
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if rpz==nil then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	if og then
		return og:IsExists(Auxiliary.PConditionFilter,1,nil,e,tp,lscale,rscale)
	else
		if Duel.IsPlayerAffectedByEffect(tp,29724053) then
			--If the player is affected by Summon Gate's effect, Pendulum Summon is possible if there is a Pendulum Summonable monster in the hand or if the player can still summon from the Extra Deck
			return Duel.IsExistingMatchingCard(Auxiliary.PConditionFilter,tp,LOCATION_HAND,0,1,nil,e,tp,lscale,rscale) or (c29724053[tp]>0 and Duel.IsExistingMatchingCard(Auxiliary.PConditionFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale))
		else
			--If Summon Gate is not in play, everything proceeds as usual
			return Duel.IsExistingMatchingCard(Auxiliary.PConditionFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale)
		end
	end
end
function c101010139.psop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=math.min(ft,1) end
	if og then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=og:FilterSelect(tp,Auxiliary.PConditionFilter,1,ft,nil,e,tp,lscale,rscale)
		sg:Merge(g)
	else
		if Duel.IsPlayerAffectedByEffect(tp,29724053) then
			--If the player is affected by Summon Gate's effect...
			local g=Duel.GetMatchingGroup(Auxiliary.PConditionFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp,lscale,rscale)
			if g:GetCount()==0 then return end
			local xg=g:Filter(Card.IsLocation,nil,LOCATION_EXTRA) --Summonable cards in Extra
			local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND) --Summonable cards in hand
			if xg:GetCount()>0 and c29724053[tp]>0 and (hg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(29724053,0))) then
				--If there are monsters in the Extra Deck and the player can summon and wants to summon from the Extra Deck...
				--NOTE: If there are no Pendulum Summonable monsters in the hand, the procedure allows to summon from the Extra without asking
				local xct=math.min(ft,c29724053[tp])
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local xsg=xg:Select(tp,1,xct,nil)
				local rl=ft-xsg:GetCount() --Remaining locations
				sg:Merge(xsg)
				if hg:GetCount()>0 and rl>0 and Duel.SelectYesNo(tp,aux.Stringid(29724053,1)) then
					--If there are summonable monsters in the hand as well and the user can and wants to continue to summon...
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local hsg=hg:Select(tp,1,rl,nil)
					sg:Merge(hsg)
				end
			else
				--If there are no valid monsters in the Extra Deck, or the user wants to summon from hand only...
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local hsg=hg:Select(tp,1,ft,nil)
				sg:Merge(hsg)
			end
		else
			--If Summon Gate is not in play, everything proceeds as usual
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,Auxiliary.PConditionFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,ft,nil,e,tp,lscale,rscale)
			sg:Merge(g)
		end
	end
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
end
